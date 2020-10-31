<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginPage.aspx.cs" Inherits="MainProject.LoginPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Prijava</title>
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <link href="Style/LoginPage.css" rel="stylesheet" />
    <script src="Scripts/bootstrap.js"></script>
    <script src="Scripts/jquery-3.0.0.js"></script>
    <script src="Scripts/popper.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container login-background">
            <div class="row">
                <div class="col-12">
                    <div class="form-group">
                        <img class="img-fluid mx-auto d-block user-pic" src="images/login.png" />
                    </div>
                    <div class="form-group custom-group">
                        <label class="login-font" for="username">Korisničko ime:</label>
                        <asp:RequiredFieldValidator ErrorMessage="Obavezno polje" ControlToValidate="txtUsername" Text="*" ForeColor="Red" runat="server" CssClass="error-label" />
                        <asp:TextBox runat="server" ID="txtUsername" CssClass="form-control" />
                    </div>
                    <div class="form-group custom-group">
                        <label class="login-font" for="password">Lozinka:</label>
                        <asp:RequiredFieldValidator ErrorMessage="Obavezno polje" ControlToValidate="txtPassword" Text="*" ForeColor="Red" runat="server" CssClass="error-label" />
                        <asp:TextBox runat="server" ID="txtPassword" CssClass="form-control" TextMode="Password" />
                    </div>
                    <asp:Button ID="btnLogin" Text="Login" runat="server" OnClick="btnLogin_Click" CssClass="btn btn-warning custom-btn mx-auto d-block" />
                    <div style="color:red; text-align: center; font-size: 1.2em">
                        <asp:Label ID="Error" runat="server" />
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
