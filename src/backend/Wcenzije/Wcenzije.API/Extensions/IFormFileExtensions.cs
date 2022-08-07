namespace Wcenzije.API.Extensions
{
    public static class IFormFileExtensions
    {
        public static async Task<byte[]> ToByteArray(this IFormFile file)
        {
            await using var memoryStream = new MemoryStream();
            await file.CopyToAsync(memoryStream);
            return memoryStream.ToArray();
        }
    }
}
