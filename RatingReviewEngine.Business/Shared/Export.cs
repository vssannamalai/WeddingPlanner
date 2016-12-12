using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.IO;
using System.Xml;
using System.Xml.Xsl;
using System.Threading;
using System.Xml.Linq;
using RatingReviewEngine.Entities;

namespace RatingReviewEngine.Business.Shared
{
    public static class Export0
    {
        public static void ToCSV<T>(this IList<T> list, string path = "", string include = "", string headerContent = "", string exclude = "")
        {
            CreateCsvFile(list, path, include, headerContent, exclude);
        }

        private static string CreateCsvFile<T>(IList<T> list, string path, string include, string headerContent, string exclude)
        {
            //Variables for build CSV string
            StringBuilder sb = new StringBuilder();
            List<string> propNames;
            List<string> propValues;
            bool isNameDone = false;

            //Get property collection and set selected property list
            PropertyInfo[] props = typeof(T).GetProperties();
            List<PropertyInfo> propList = GetSelectedProperties(props, include, exclude);

            //Add list name and total count
            /* string typeName = GetSimpleTypeName(list);
             sb.AppendLine(string.Format("{0} List - Total Count: {1}", typeName, list.Count.ToString()));
             */
            //Iterate through data list collection
            foreach (var item in list)
            {
                sb.AppendLine("");
                propNames = new List<string>();
                propValues = new List<string>();

                //Iterate through property collection
                foreach (var prop in propList)
                {
                    //Construct property name string if not done in sb
                    if (!isNameDone) propNames.Add(prop.Name);

                    //Construct property value string with double quotes for issue of any comma in string type data
                    var val = prop.PropertyType == typeof(string) ? "\"{0}\"" : "{0}";
                    propValues.Add(string.Format(val, prop.GetValue(item, null)));
                }
                //Add line for Names
                string line = string.Empty;
                if (!isNameDone)
                {
                    line = string.Join(",", propNames);
                    sb.AppendLine(string.IsNullOrEmpty(headerContent) ? line : headerContent);
                    isNameDone = true;
                }
                //Add line for the values
                line = string.Join(",", propValues);
                sb.Append(line);
            }
            if (!string.IsNullOrEmpty(sb.ToString()) && path != "")
            {
                File.WriteAllText(path, sb.ToString());
            }
            return path;
        }

        private static List<PropertyInfo> GetSelectedProperties(PropertyInfo[] props, string include, string exclude)
        {
            List<PropertyInfo> propList = new List<PropertyInfo>();
            if (include != "") //Do include first
            {
                var includeProps = include.ToLower().Split(',').ToList();

                foreach (var item in includeProps)
                {
                    var prop = props.Where(a => a.Name.ToLower() == item).FirstOrDefault();
                    if (prop != null)
                        propList.Add(prop);
                }

                //foreach (var item in props)
                //{
                //    var propName = includeProps.Where(a => a == item.Name.ToLower()).FirstOrDefault();
                //    if (!string.IsNullOrEmpty(propName))
                //        propList.Add(item);
                //}
            }
            else if (exclude != "") //Then do exclude
            {
                var excludeProps = exclude.ToLower().Split(',');
                foreach (var item in props)
                {
                    var propName = excludeProps.Where(a => a == item.Name.ToLower()).FirstOrDefault();
                    if (string.IsNullOrEmpty(propName))
                        propList.Add(item);
                }
            }
            else //Default
            {
                propList.AddRange(props.ToList());
            }
            return propList;
        }

        private static string GetSimpleTypeName<T>(IList<T> list)
        {
            string typeName = list.GetType().ToString();
            int pos = typeName.IndexOf("[") + 1;
            typeName = typeName.Substring(pos, typeName.LastIndexOf("]") - pos);
            typeName = typeName.Substring(typeName.LastIndexOf(".") + 1);
            return typeName;
        }


        public static void ToXML<T>(this IList<T> list, string path = "", string include = "", string headerContent = "", string exclude = "")
        {
            CreateXmlFile(list, path, include, headerContent, exclude);
        }

        private static string CreateXmlFile<T>(IList<T> list, string path, string include, string headerContent, string exclude)
        {
            List<string> propNames = headerContent.Split(',').ToList();
            //List<string> propValues;


            //Get property collection and set selected property list
            PropertyInfo[] props = typeof(T).GetProperties();
            List<PropertyInfo> propList = GetSelectedProperties(props, include, exclude);


            using (XmlWriter writer = XmlWriter.Create(path))
            {
                writer.WriteStartDocument();
                writer.WriteStartElement("root");

                foreach (var item in list)
                {
                    writer.WriteStartElement("element");
                    foreach (var prop in propList)
                    {
                        //Construct property value string with double quotes for issue of any comma in string type data
                        var val = prop.PropertyType == typeof(string) ? "\"{0}\"" : "{0}";
                        writer.WriteElementString(prop.Name, (string.Format(val, prop.GetValue(item, null))));
                    }
                    writer.WriteEndElement();
                }
                 
                writer.WriteEndElement();
                writer.WriteEndDocument();
            }


            return path;
        }

        private static string ReplaceSpclChars(string fieldName)
        {
            //			space 	-> 	_x0020_
            //			%		-> 	_x0025_
            //			#		->	_x0023_
            //			&		->	_x0026_
            //			/		->	_x002F_

            fieldName = fieldName.Replace(" ", "_x0020_");
            fieldName = fieldName.Replace("%", "_x0025_");
            fieldName = fieldName.Replace("#", "_x0023_");
            fieldName = fieldName.Replace("&", "_x0026_");
            fieldName = fieldName.Replace("/", "_x002F_");
            return fieldName;
        }


        public static void ToXMLSupplierTransaction(this List<SupplierCommunityTransactionHistory> list, string path)
        {

            using (XmlWriter writer = XmlWriter.Create(path))
            {
                writer.WriteStartDocument();
                writer.WriteStartElement("root");

                foreach (SupplierCommunityTransactionHistory transaction in list)
                {
                    writer.WriteStartElement("element");

                    writer.WriteElementString("Community", transaction.CommunityName.ToString());
                    writer.WriteElementString("Community Group", transaction.CommunityGroupName);
                    writer.WriteElementString("Customer", transaction.CustomerName);
                    writer.WriteElementString("Date", transaction.DateApplied.ToString());
                    writer.WriteElementString("Amount", transaction.Amount.ToString());
                    writer.WriteElementString("Balance", transaction.Balance.ToString());

                    writer.WriteEndElement();
                }

                writer.WriteEndElement();
                writer.WriteEndDocument();
            }
        }

    }

}
