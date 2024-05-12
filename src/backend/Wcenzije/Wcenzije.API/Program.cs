using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Microsoft.AspNetCore.Identity;
using Wcenzije.API;
using Wcenzije.Domain.Repositories;
using Wcenzije.Domain.Services;
using Wcenzije.Persistence;
using Wcenzije.Persistence.Repositories;

const string CorsPolicy = "allowAnyOrigin";

var builder = WebApplication.CreateBuilder(args);
builder.Configuration.AddJsonFile("appsettings.json");
builder.Services.AddControllers();
builder.Services.AddScoped<IReviewsRepository, ReviewsRepository>();
builder.Services.AddScoped<IUserRepository, UserRepository>();
builder.Services.AddScoped<IImageUploadService, CloudinaryImageUploadService>();
builder.Services.SetupAndAddDbContext(builder.Configuration);
builder.Services.AddCorsForAnyOrigin(CorsPolicy);

builder.AddAndConfigureAuthentication();
builder.AddAndConfigureAuthorization();

var app = builder.Build();
//app.UseHttpsRedirection();

app.UseCors(CorsPolicy);
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
app.MigrateDatabase();
app.Run();