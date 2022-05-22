using Wcenzije.API.Models;

namespace Wcenzije.API.Data
{
    public class FakeReviewsRepository : IReviewsRepository
    {
        public List<Review> GetReviews()
        {
            return new List<Review>()
            {
                new Review
                {
                    Content = "This is a test review.",
                    LikeCount = 65,
                    ImageUrls = new List<string>{"https://i.imgur.com/JRsltsu.jpeg"}
                },
                new Review
                {
                    Content = "This is another test review.",
                    LikeCount = 34,
                    ImageUrls = new List<string>{"https://i.imgur.com/JRsltsu.jpeg"}
                },
            };
        }
    }
}
