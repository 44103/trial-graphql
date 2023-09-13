import { util } from "@aws-appsync/utils";

export function request(ctx) {
  const { id, expectedVersion } = ctx.arguments;

  let condition = null;
  if (expectedVersion) {
    condition = JSON.parse(
      util.transform.toDynamoDBConditionExpression({
        or: [
          { id: { attributeExists: false } },
          { version: { eq: expectedVersion } },
        ],
      })
    );
  }
  return {
    version: "2018-05-29",
    operation: "DeleteItem",
    key: util.dynamodb.toMapValues({ id }),
    condition,
  };
}

export function response(ctx) {
  const { error, result } = ctx;
  if (error) {
    util.appendError(error.message, error.type);
  }
  return result;
}
