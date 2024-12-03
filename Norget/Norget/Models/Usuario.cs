using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using MySqlX.XDevAPI;

namespace Norget.Models
{
    public class Usuario
    {
        public int Id { get; set; }

        // [Required]
        //  [StringLength(200)]
        public string? NomeCli { get; set; }

        // [Required]
        // [EmailAddress]
        // [StringLength(50)]
        public string? EmailCli { get; set; }

        //  [Required]
        public string? SenhaCli { get; set; }

        // [Required]
        public int Tel { get; set; }
        public List<Usuario>? ListaUsuario { get; set; }
        public bool NivelAcesso { get; set; }

    }
}
