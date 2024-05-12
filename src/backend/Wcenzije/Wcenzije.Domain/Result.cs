namespace Wcenzije.Domain;

public class Result
{
    public ResultStatus Status { get; init; }
    public string? Message { get; set; }

    protected Result()
    {
    }

    public static Result Ok(string? message = null) => new Result
    {
        Status = ResultStatus.Ok,
        Message = message
    };

    public static Result Fail(string message) => new Result
    {
        Message = message,
        Status = ResultStatus.Failure
    };
    
    public static Result Unauthorized() => new Result
    {
        Status = ResultStatus.Unauthorized
    };
}

public class Result<T> : Result
{
    public T? Value { get; private init; }

    private Result()
    {
    }

    public static Result<T> Ok(T value, string? message = null) => new()
    {
        Value = value,
        Message = message,
        Status = ResultStatus.Ok
    };
    
    public new static Result<T> Fail(string message) => new Result<T>
    {
        Message = message,
        Status = ResultStatus.Failure
    };

    public static Result<T> Created(T value) => new()
    {
        Value = value,
        Status = ResultStatus.Created
    };
    
    public new static Result<T> Unauthorized() => new()
    {
        Status = ResultStatus.Unauthorized
    };
}

public enum ResultStatus
{
    Ok,
    Created,
    Failure,
    Unauthorized
}