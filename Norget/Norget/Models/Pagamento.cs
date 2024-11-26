namespace Norget.Models
{
    public class Pagamento
    {
        
        public int Id { get; set; }
        
        public string NomeCartao { get; set; }

        public string NumeroCartao { get; set; }

        public string DataExpiracao { get; set; }

        /*
        public int CVV { get; set; } // Sla oq q é cvvkkkkkkkk

        public string BillingAddress { get; set; } // Porréssakkkkkkkkkk
        */
    }
}
