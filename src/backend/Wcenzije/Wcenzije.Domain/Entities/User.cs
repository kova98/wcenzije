using Microsoft.AspNetCore.Identity;

namespace Wcenzije.Domain.Entities;

public class User : IdentityUser
{
    public string[]? UserRoles { get; set; } = [];
}