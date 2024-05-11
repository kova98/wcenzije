using Microsoft.AspNetCore.Http;

namespace Wcenzije.Domain.Services
{
    public interface IImageUploadService
    {
        Task<List<string>> Upload(ICollection<IFormFile> files);
    }
}