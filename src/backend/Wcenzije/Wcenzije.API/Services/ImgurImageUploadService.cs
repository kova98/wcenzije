using System.Net.Http.Headers;
using Wcenzije.API.Extensions;

namespace Wcenzije.API.Services
{
    public class ImgurImageUploadService : IImageUploadService
    {
        private const string UploadUrl = "https://api.imgur.com/3/upload";
        
        private readonly HttpClient _httpClient;

        public ImgurImageUploadService()
        {
            _httpClient = new HttpClient();
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Client-ID", GetClientId());
        }

        public async Task<List<string>> Upload(ICollection<IFormFile> files)
        {
            var imageUrls = new List<string>();

            foreach (var file in files)
            {
                var requestContent = new MultipartFormDataContent
                {
                    new ByteArrayContent(await file.ToByteArray())
                };

                var response = await _httpClient.PostAsync(UploadUrl, requestContent);

                response.EnsureSuccessStatusCode();

                var content = await response.Content.ReadFromJsonAsync<UploadResponse>();

                imageUrls.Add(content.Data.Link); 
            }

            return imageUrls;
        }

        private static string GetClientId()
        {
            var clientId = Environment.GetEnvironmentVariable("IMGUR_CLIENT_ID");

            if (clientId == null)
            {
                throw new Exception("Environment variable IMGUR_CLIENT_ID not found.");
            }

            return clientId;
        }


        private class UploadResponse
        {
            public Data Data { get; set; }
        }

        private class Data
        {
            public string Link { get; set; }
        }
    }

    
}
