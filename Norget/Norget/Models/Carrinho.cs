namespace Norget.Models
{
    public class Carrinho
    {
        public List<Livro> Livro { get; set; } = new List<Livro>();
        public decimal ValorTotal { get; set; }
    }
}
