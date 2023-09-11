import { util } from "@aws-appsync/utils";

export function request(ctx) {
  const { id, expectedVersion, ...values } = ctx.args;
  const condition = { version: { eq: expectedVersion } };
  return dynamodbUpdateRequest({ key: { id }, values, condition });
}

export function response(ctx) {
  const { error, result } = ctx;
  if (error) {
    util.appendError(error.message, error.type);
  }
  return result;
}

/**
 * Helper function to update an item in DynamoDB
 */
function dynamodbUpdateRequest({ key, values, condition }) {
  const sets = [];
  const removes = [];
  const expressionNames = {};
  const expValues = {};

  // iterate through the entries (key,value) of the values to be updated
  for (const [k, value] of Object.entries(values)) {
    // set the name
    expressionNames[`#${k}`] = k;
    if (value && value.length) {
      // if the value exists, add it to the list to be SET
      sets.push(`#${k} = :${k}`);
      expValues[`:${k}`] = value;
    } else {
      // if not, markt it to be removed
      removes.push(`#${k}`);
    }
  }

  let expression = sets.length ? `SET ${sets.join(", ")}` : "";
  expression += removes.length ? ` REMOVE ${removes.join(", ")}` : "";

  // increase the value of the version by 1
  expressionNames["#version"] = "version";
  expValues[":version"] = 1;
  expression += " ADD #version :version";

  return {
    operation: "UpdateItem",
    key: util.dynamodb.toMapValues(key),
    update: {
      expression,
      expressionNames,
      expressionValues: util.dynamodb.toMapValues(expValues),
    },
    condition: JSON.parse(
      util.transform.toDynamoDBConditionExpression(condition)
    ),
  };
}
