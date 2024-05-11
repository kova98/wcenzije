using Wcenzije.Domain;

namespace Wcenzije.API;

public record ErrorBody(string Error);

public static class ResultExtensions
{
    public static IResult ToHttpResult<T>(this Result<T> result, string? location = null) => result.Status switch
    {
        ResultStatus.Ok => Results.Ok(result.Value),
        ResultStatus.Failure => Results.BadRequest(new ErrorBody(result.Message!)),
        ResultStatus.Created => Results.Created($"{location}/{result.Value}", null),
        _ => throw new ArgumentOutOfRangeException(nameof(result.Status), result.Status, null)
    };
    
    public static IResult ToHttpResult(this Result result) => result.Status switch
    {
        ResultStatus.Ok => Results.NoContent(),
        ResultStatus.Failure => Results.BadRequest(new ErrorBody(result.Message!)),
        _ => throw new ArgumentOutOfRangeException(nameof(result.Status), result.Status, null)
    };
}