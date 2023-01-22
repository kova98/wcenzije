﻿using Microsoft.AspNetCore.Identity;

namespace Wcenzije.API.Entities;

public class User : IdentityUser
{
    public string[] UserRoles { get; set; }
}