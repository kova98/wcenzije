using CloudinaryDotNet;
using CloudinaryDotNet.Actions;
using Microsoft.AspNetCore.Http;
using Wcenzije.Domain.Services;

namespace Wcenzije.Persistence
{
    public class CloudinaryImageUploadService : IImageUploadService
    {
        const string Cloud = "wcenzije";
        const string ApiKey = "231846372339387";
        const string ApiSecret = "UvnU0kwjaqR2gkafOEWDDg35N5U";

        public async Task<List<string>> Upload(ICollection<IFormFile> files)
        {
            var imageUrls = new List<string>();

            var account = new Account(Cloud, ApiKey, ApiSecret);
            var cloudinary = new Cloudinary(account);
            cloudinary.Api.Secure = true;

            foreach (var file in files)
            {
                using var memoryStream = new MemoryStream();
                await file.CopyToAsync(memoryStream);
                memoryStream.Position = 0;

                var uploadparams = new ImageUploadParams
                {
                    File = new FileDescription(file.FileName, memoryStream),
                };

                var result = cloudinary.Upload(uploadparams);

                if (result.Error != null)
                {
                    throw new Exception($"Cloudinary error occured: {result.Error}");
                }

                imageUrls.Add(result.SecureUrl.ToString());
            }

            return imageUrls;
        }
    }
}
