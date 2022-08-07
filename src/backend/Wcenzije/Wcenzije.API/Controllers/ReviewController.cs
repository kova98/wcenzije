using Microsoft.AspNetCore.Mvc;
using Wcenzije.API.Data;
using Wcenzije.API.Entities;
using Wcenzije.API.Extensions;
using Wcenzije.API.Services;

namespace Wcenzije.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReviewController : ControllerBase
    {
        private readonly IReviewsRepository _reviewsRepo;
        private readonly IImageUploadService _imageUploadService;

        public ReviewController(IReviewsRepository reviewsRepo, IImageUploadService imageUploadService)
        {
            _reviewsRepo = reviewsRepo;
            _imageUploadService = imageUploadService;
        }

        [HttpGet]
        public List<Review> GetReviews() => _reviewsRepo
            .GetReviews()
            .Where(LocationIsValid)
            .ToList();

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

            return CreatedAtAction(nameof(GetReview), new { Id = review.Id}, review);
        }

        [HttpPost("{id}/images")]
        [DisableRequestSizeLimit]
        public async Task<IActionResult> AddImagesToReview(long id, [FromForm]List<IFormFile> files)
        {
            var review = _reviewsRepo.GetReview(id);

            if (review == null) return NotFound();

            review.ImageUrls = await _imageUploadService.Upload(files);

            _reviewsRepo.UpdateReview(review);

            return Ok();
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

        private bool LocationIsValid(Review arg)
        {
            if (string.IsNullOrEmpty(arg.Location)) return false;   

            var locationStrings = arg.Location.Split(',');

            if (locationStrings.Length != 2) return false;
            
            var latValid = double.TryParse(locationStrings[0], out _);
            var lngValid = double.TryParse(locationStrings[1], out _);

            return latValid && lngValid;
        }
    }
}
