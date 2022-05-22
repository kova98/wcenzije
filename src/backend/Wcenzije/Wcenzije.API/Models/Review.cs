namespace Wcenzije.API.Models
{
    public class Review
    {
        // image urls, content, like count, location
        public List<string> ImageUrls { get; set; }
        public string Content { get; set; }
        public int LikeCount { get; set; }
    }
}
