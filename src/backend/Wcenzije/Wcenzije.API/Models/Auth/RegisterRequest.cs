using System.ComponentModel.DataAnnotations;

namespace Wcenzije.API.Models.Auth;

public class RegisterRequest
{
    [EmailAddress]
    public string Email { get; set; }

    [MinLength(4)]
    public string Username { get; set; }

    public string Password { get; set; }
}