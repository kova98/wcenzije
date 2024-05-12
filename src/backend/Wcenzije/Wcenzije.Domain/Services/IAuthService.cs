namespace Wcenzije.Domain.Services;

public record LoginResponse(string Token, DateTime Expiration);

public interface IAuthService
{
    Task<Result> Register(string email, string username, string password);
    Task<Result<LoginResponse>> Login(string username, string password);
    Task<Result> DeleteAccount(string username);
}