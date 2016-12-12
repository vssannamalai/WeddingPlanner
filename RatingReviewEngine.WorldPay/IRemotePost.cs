using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.WorldPay
{
    public interface IRemotePost
    {
        void AddInput(string name, object value);
        System.Collections.Specialized.NameValueCollection InputValues { get; set; }
        FormMethod Method { get; set; }
        void Post(string formName);
        string Url { get; set; }
    }
}
