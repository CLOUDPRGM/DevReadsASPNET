using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using MySql.Data.Types;

namespace Norget.Models;

public class Livro
{
    public int IdLiv { get; set; }

    [Column(TypeName = "decimal(13, 0)")]
    [DisplayFormat(DataFormatString = "{0:0}", ApplyFormatInEditMode = true)] //Tira os zeros
    public decimal ISBN { get; set; }

    public string? NomeLiv { get; set; }

    public decimal PrecoLiv { get; set; }

    public string? DescLiv { get; set; }

    public string? ImgLiv { get; set; }

    public string? Autor { get; set; }

    [Column(TypeName = "date")]
    [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)] //Tira a hora 
    public DateTime? DataPubli { get; set; }

    public bool NoCarrinho { get; set; }

    public int IdEdi { get; set; }
    public Editora? Editora { get; set; }

    public string? NomeEdi { get; set; }

    public string? NomeCategoria { get; set; }

    public int IdCategoria { get; set; }
    public Categoria? Categoria { get; set; }

    public enum EspecialLiv
    {
        P,
        S,
        O,
        D,
        N
    }

    public EspecialLiv EspeciaLiv { get; set; }

    public List<Livro>? ListaLivro { get; set; }

    internal static Livro Where(Func<object, bool> value)
    {
        throw new NotImplementedException();
    }
}