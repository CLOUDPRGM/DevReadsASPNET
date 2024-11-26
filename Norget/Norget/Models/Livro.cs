using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using MySql.Data.Types;

namespace Norget.Models;

public class Livro
{
    public int IdLiv { get; set; }
   
    [Column(TypeName = "decimal(13, 0)")]
    public decimal ISBN { get; set; }

  //  [Required]
   // [StringLength(100)]
    public string? NomeLiv { get; set; }

  //  [Required]
  //  [Column(TypeName = "decimal(6, 2)")]
    public decimal PrecoLiv { get; set; }

 //   [Required]
  //  [StringLength(250)]
    public string? DescLiv { get; set; }

    
  //  [Required]
    public string? ImgLiv { get; set; } 
    

  //  [Required]
  //  [StringLength(100)]
    public string? Categoria { get; set; }

  //  [Required]
  //  [StringLength(100)]
    public string? Autor { get; set; }

    //  [Required]
    [Column(TypeName = "date")]
    public DateTime? DataPubli { get; set; }

    // Chave estrangeira para Editora
    public string? NomeEdi { get; set; }

    public int IdEdi { get; set; }
    public Editora? Editora { get; set; }

    public List<Livro>? ListaLivro { get; set; }

}