using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Wcenzije.API.Models.Review;
using Wcenzije.Domain.Repositories;

namespace Wcenzije.API.Controllers;

[Route("api/v2/review")]
[Authorize]
[ApiController]
public class ReviewControllerV2 : ControllerBase
{
    private readonly IReviewsRepository _reviewsRepo;
    
    public ReviewControllerV2(IReviewsRepository reviewsRepo)
    {
        _reviewsRepo = reviewsRepo;
    }
    
    [AllowAnonymous]
    [HttpGet]
    public IActionResult GetReviews([FromQuery] GetReviewsRequest request)
    {
        var reviews = _reviewsRepo.GetReviews(request.Page, request.PageSize, request.IdsArray.ToList());
        var response = new GetReviewsResponse(reviews);
        return Ok(response);
    }
    
    [AllowAnonymous]
    [HttpGet("map")]
    public IActionResult GetReviewsForMap()
    {
        var reviews = _reviewsRepo.GetAllReviewsSimple();
        
        return Ok(reviews);
    }
    
}