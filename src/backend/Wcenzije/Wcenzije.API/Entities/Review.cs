namespace Wcenzije.API.Entities
{
    public class Review
    {
        public long Id { get; set; }
        public List<string> ImageUrls { get; set; }
        public string Content { get; set; }
        public int LikeCount { get; set; }
    }
}
