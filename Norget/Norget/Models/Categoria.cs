namespace Norget.Models
{
    public class Categoria
    {
        public int IdCategoria { get; set; }

        public string? NomeCategotia { get; set; }

        public ICollection<Livro> Livros { get; set; } = new List<Livro>();
    }
}
