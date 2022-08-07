namespace Wcenzije.API.Services
{
    public interface IImageUploadService
    {
        Task<List<string>> Upload(ICollection<IFormFile> files);
    }
}