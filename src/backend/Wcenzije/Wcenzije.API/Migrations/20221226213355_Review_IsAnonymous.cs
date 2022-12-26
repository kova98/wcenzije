using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Wcenzije.API.Migrations
{
    public partial class Review_IsAnonymous : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsAnonymous",
                table: "Reviews",
                type: "boolean",
                nullable: false,
                defaultValue: false);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsAnonymous",
                table: "Reviews");
        }
    }
}
