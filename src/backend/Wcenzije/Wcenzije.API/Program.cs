using Wcenzije.API;
using Wcenzije.API.Data;
using Wcenzije.API.Services;

var builder = WebApplication.CreateBuilder(args);
builder.Configuration.AddJsonFile("appsettings.json");
builder.Services.AddControllers();
builder.Services.AddScoped<IReviewsRepository, ReviewsRepository>();
builder.Services.AddScoped<IImageUploadService, CloudinaryImageUploadService>();
builder.Services.SetupAndAddDbContext(builder.Configuration);

var app = builder.Build();
//app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.MigrateDatabase();
app.Run();