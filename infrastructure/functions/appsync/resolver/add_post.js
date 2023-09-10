import { util } from "@aws-appsync/utils";

export function request(ctx) {
  const values = ctx.arguments;
  values.ups = 1;
  values.downs = 0;
  values.version = 1;
  const key = { id: ctx.args.id ?? util.autoId() };
  return {
    operation: "PutItem",
    key: util.dynamodb.toMapValues(key),
    attributeValues: util.dynamodb.toMapValues(values),
  };
}

export function response(ctx) {
  return ctx.result;
}
