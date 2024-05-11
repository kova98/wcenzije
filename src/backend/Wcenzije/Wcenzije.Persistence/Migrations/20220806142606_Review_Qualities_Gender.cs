using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Wcenzije.API.Migrations
{
    public partial class Review_Qualities_Gender : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "Gender",
                table: "Reviews",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<long>(
                name: "QualitiesId",
                table: "Reviews",
                type: "bigint",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "Qualities",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    HasSoap = table.Column<bool>(type: "boolean", nullable: false),
                    HasToiletPaper = table.Column<bool>(type: "boolean", nullable: false),
                    HasPaperTowels = table.Column<bool>(type: "boolean", nullable: false),
                    IsClean = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Qualities", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Reviews_QualitiesId",
                table: "Reviews",
                column: "QualitiesId");

            migrationBuilder.AddForeignKey(
                name: "FK_Reviews_Qualities_QualitiesId",
                table: "Reviews",
                column: "QualitiesId",
                principalTable: "Qualities",
                principalColumn: "Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Reviews_Qualities_QualitiesId",
                table: "Reviews");

            migrationBuilder.DropTable(
                name: "Qualities");

            migrationBuilder.DropIndex(
                name: "IX_Reviews_QualitiesId",
                table: "Reviews");

            migrationBuilder.DropColumn(
                name: "Gender",
                table: "Reviews");

            migrationBuilder.DropColumn(
                name: "QualitiesId",
                table: "Reviews");
        }
    }
}
