using Microsoft.AspNetCore.Mvc;
using Wcenzije.API.Models.Auth;
using Wcenzije.Domain.Services;

namespace Wcenzije.API.Controllers;

[Route("api/auth")]
[ApiController]
public class AuthController(IAuthService authService) : ControllerBase
{
    [HttpPost]
    [Route("register")]
    public async Task<IResult> Register([FromBody] RegisterRequest request)
    {
        var result = await authService.Register(request.Email, request.Username, request.Password);
        return result.ToHttpResult();
    }

    [HttpPost]
    [Route("login")]
    public async Task<IResult> Login([FromBody] LoginRequest request)
    {
        var result = await authService.Login(request.Username, request.Password);
        return result.ToHttpResult();
    }

}