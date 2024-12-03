namespace Norget.Models
{
    public class HomeViewModel
    {
            public List<Livro> Populares { get; set; }
            public Livro LivroDaSemana { get; set; }
            public List<Livro> Ofertas { get; set; }
            public List<Livro> Outros { get; set; }     

    }
}
