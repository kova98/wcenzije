using Microsoft.AspNetCore.Mvc;
using Wcenzije.API.Data;
using Wcenzije.API.Entities;

namespace Wcenzije.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReviewController : ControllerBase
    {
        private readonly IReviewsRepository _reviewsRepo;

        public ReviewController(IReviewsRepository reviewsRepo)
        {
            _reviewsRepo = reviewsRepo;
        }

        [HttpGet]
        public List<Review> GetReviews() => _reviewsRepo.GetReviews();


        [HttpGet("{id}", Name = nameof(GetReview))]
        public IActionResult GetReview(long id)
        {
            var review = _reviewsRepo.GetReview(id);
            return review == null ? NotFound() : Ok(review);
        }

        [HttpPost]
        public IActionResult CreateReview(Review review)
        {
            _reviewsRepo.CreateReview(review);

            return CreatedAtAction(nameof(GetReview), review);
        }

        [HttpPut]
        public IActionResult EditReview(Review review)
        {
            var reviewToUpdate = _reviewsRepo.GetReview(review.Id);

            if (reviewToUpdate == null) return NotFound();

            _reviewsRepo.UpdateReview(review);

            return Ok(reviewToUpdate);
        }


        [HttpDelete("{id}")]
        public IActionResult DeleteReview(long id)
        {
            var review = _reviewsRepo.GetReview(id);

            if (review == null) return NotFound();

            _reviewsRepo.DeleteReview(id);

            return Ok();
        }
    }
}
