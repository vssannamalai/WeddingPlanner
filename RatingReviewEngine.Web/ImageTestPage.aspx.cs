using System;
using System.Collections.Generic;
using System.Drawing.Imaging;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RatingReviewEngine.Web
{
    public partial class ImageTestPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ResizeImage();
        }

        public void ResizeImage()
        {
            try
            {

                 
                {

                    string imagePath = @"F:\Original.jpg";
                    string resizeImagePath = @"F:\Resized.jpeg";
                    ResizeImage(imagePath, resizeImagePath, 298, 236);
                }
            }
            catch (Exception ex)
            {

            }
        }

        public void ResizeImage(string imageFilePath, string resizeImagePath, int width, int height)
        {
            try
            {
                int x = 0;
                int y = 0;
                int newX = 0;
                int newY = 0;

                System.Drawing.Image objImage = System.Drawing.Image.FromFile(imageFilePath);
                objImage.RotateFlip(System.Drawing.RotateFlipType.Rotate270FlipY);

                x = objImage.Width;
                y = objImage.Height;

                if (x > height || y > width)
                {
                    if (x*1.0/y >= height*1.0/width)
                    {
                        newX = height;
                        newY = Convert.ToInt32(y*(height*1.0/x));
                    }
                    else
                    {
                        newY = width;
                        newX = Convert.ToInt32(x*(width*1.0/y));
                    }
                }
                else
                {
                    newX = x;
                    newY = y;
                }

                newX = 250;
                newY = 300;

                System.Drawing.Image.GetThumbnailImageAbort objCallback =
                    new System.Drawing.Image.GetThumbnailImageAbort(fooCallback);
                System.Drawing.Image objNewImage = objImage.GetThumbnailImage(newX, newY, objCallback, IntPtr.Zero);
                objNewImage.RotateFlip(System.Drawing.RotateFlipType.Rotate270FlipY);

                objNewImage.Save(resizeImagePath, ImageFormat.Jpeg);

                objImage.Dispose();
                objNewImage.Dispose();
            }
            catch (Exception ex)
            {

            }
        }

        private bool fooCallback()
        {
            return false;
        }
    }
}
 