using System.ComponentModel.DataAnnotations;

namespace Norget.Models
{
    public class Venda
    {
        public int NumeroVenda { get; set; }

        [Required]
        public DateTime DataVenda { get; set; }

        [Required]
        public decimal ValorTotal { get; set; }

        [Required]
        public int QtdTotal { get; set; }

        public int IdEdi { get; set; }
        public Editora Editora { get; set; }

        public ICollection<Carrinho> ItensVenda { get; set; }
    }
}
