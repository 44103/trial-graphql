import { util } from "@aws-appsync/utils";

export function request(ctx) {
  const { source, args } = ctx;
  return {
    operation: ctx.info.fieldName === "relatedPosts" ? "BatchInvoke" : "Invoke",
    payload: { field: ctx.info.fieldName, arguments: args, source },
  };
}

export function response(ctx) {
  const { error, result } = ctx;
  if (error) {
    util.appendError(error.message, error.type, result);
  } else if (result.errorMessage) {
    util.appendError(result.errorMessage, result.errorType, result.data);
  } else if (ctx.info.fieldName === "relatedPosts") {
    return result.data;
  } else {
    return result;
  }
}
