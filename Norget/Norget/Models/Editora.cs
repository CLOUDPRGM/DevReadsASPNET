using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace Norget.Models
{
    public class Editora
    {
        public int IdEdi { get; set; }

        [Required]
        [Column(TypeName = "decimal(11, 0)")]
        public decimal CNPJ { get; set; }

        [Required]
        [StringLength(30)]
        public string? NomeEdi { get; set; }

        public int? TelEdi { get; set; }

        public ICollection<Livro> Livros { get; set; } = new List<Livro>();

    }
}
