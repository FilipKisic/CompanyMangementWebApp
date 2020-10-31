<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TeamLeaderDashboard.aspx.cs" Inherits="MainProject.TeamLeaderDashboard" %>

<%@ Register Src="~/Components/NavBar.ascx" TagPrefix="uc1" TagName="NavBar" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Početna stranica</title>
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <link href="Style/AdminDashboard.css" rel="stylesheet" />
    <script src="Scripts/jquery-3.5.0.js"></script>
    <script src="Scripts/bootstrap.js"></script>
    <script src="Scripts/popper.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <%--Feature to add: toggle sidebar for settings--%>
        <uc1:NavBar runat="server" ID="NavBar" />
        <div class="container-fluid padding">
            <div class="row">
                <div class="col-12 greeting">
                    <h1 runat="server" id="h1Greeting">Pozdrav, voditelju!</h1>
                </div>
            </div>
            <div class="row d-flex justify-content-center">
                <!-- 1st card start-->
                <div class="col-lg-3 col-md-6 col-sm-12">
                    <div class="card custom-card">
                        <asp:Image ID="TeamImage" runat="server" ImageUrl="~/Icons/group.svg" CssClass="card-img-top" />
                        <div class="card-body">
                            <h1 class="text-center card-inner-title">Timovi</h1>
                            <asp:HyperLink ID="SelectTeams" runat="server" NavigateUrl="SitesTeam/TeamSelectDeactivate.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="SelectTeamsIcon" runat="server" ImageUrl="~/Icons/user.svg" CssClass="inline-img" />
                                    Pregled timova
                                </h5>
                            </asp:HyperLink>
                            <asp:HyperLink ID="NewTeam" runat="server" NavigateUrl="SitesTeam/TeamAddUpdate.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="NewTeamIcon" runat="server" ImageUrl="~/Icons/add.svg" CssClass="inline-img" />
                                    Novi tim
                                </h5>
                            </asp:HyperLink>
                            <asp:HyperLink ID="EditTeam" runat="server" NavigateUrl="SitesTeam/TeamAddUpdate.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="EditTeamIcon" runat="server" ImageUrl="~/Icons/edit.svg" CssClass="inline-img" />
                                    Uredi tim
                                </h5>
                            </asp:HyperLink>
                            <asp:HyperLink ID="DeactivateTeam" runat="server" NavigateUrl="SitesTeam/TeamSelectDeactivate.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="DeactivateTeamIcon" runat="server" ImageUrl="~/Icons/remove.svg" CssClass="inline-img" />
                                    Deaktiviraj tim
                                </h5>
                            </asp:HyperLink>
                        </div>
                    </div>
                </div>
                <!-- 1st card end-->
                <!-- 2nd card start-->
                <div class="col-lg-3 col-md-6 col-sm-12">
                    <div class="card custom-card">
                        <asp:Image ID="ProjectImage" runat="server" ImageUrl="~/Icons/start-up.svg" CssClass="card-img-top" />
                        <div class="card-body">
                            <h1 class="text-center card-inner-title">Projekti</h1>
                            <asp:HyperLink ID="SelectProjects" runat="server" NavigateUrl="SitesProject/ProjectSelectDeactivate.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="SelectProjectsIcon" runat="server" ImageUrl="~/Icons/document.svg" CssClass="inline-img" />
                                    Pregled projekata
                                </h5>
                            </asp:HyperLink>
                            <asp:HyperLink ID="NewProject" runat="server" NavigateUrl="SitesProject/ProjectAddUpdate.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="NewProjectIcon" runat="server" ImageUrl="~/Icons/plus.svg" CssClass="inline-img" />
                                    Novi projekt
                                </h5>
                            </asp:HyperLink>
                            <asp:HyperLink ID="EditProject" runat="server" NavigateUrl="SitesProject/ProjectAddUpdate.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="EditProjectIcon" runat="server" ImageUrl="~/Icons/edit.svg" CssClass="inline-img" />
                                    Uredi projekt
                                </h5>
                            </asp:HyperLink>
                            <asp:HyperLink ID="DeactivateProject" runat="server" NavigateUrl="SitesProject/ProjectSelectDeactivate.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="DeactivateProjectIcon" runat="server" ImageUrl="~/Icons/trash.svg" CssClass="inline-img" />
                                    Deaktiviraj projekt
                                </h5>
                            </asp:HyperLink>
                        </div>
                    </div>
                </div>
                <!-- 2nd card end-->
                <!-- 3rd card start-->
               <div class="col-lg-3 col-md-6 col-sm-12">
                    <div class="card custom-card">
                        <asp:Image ID="Image11" runat="server" ImageUrl="~/Icons/file.svg" CssClass="card-img-top" />
                        <div class="card-body">
                            <h1 class="text-center card-inner-title">Izvještaji</h1>
                            <asp:HyperLink ID="TeamReports" runat="server" NavigateUrl="SitesReports/TeamReports.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="TeamReportsIcon" runat="server" ImageUrl="~/Icons/clock.svg" CssClass="inline-img" />
                                    Izvještaji za timove
                                </h5>
                            </asp:HyperLink>
                            <asp:HyperLink ID="ClientReports" runat="server" NavigateUrl="SitesReports/ClientReports.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="ClientReportsIcon" runat="server" ImageUrl="~/Icons/bar-chart.svg" CssClass="inline-img" />
                                    Izvještaji za klijente
                                </h5>
                            </asp:HyperLink>
                            <asp:HyperLink ID="SelectClients" runat="server" NavigateUrl="SitesClient/ClientAddUpdate.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="SelectClientsIcon" runat="server" ImageUrl="~/Icons/piggy-bank.svg" CssClass="inline-img" />
                                    Pregled klijenata
                                </h5>
                            </asp:HyperLink>
                            <asp:HyperLink ID="AddEditClients" runat="server" NavigateUrl="SitesClient/ClientSelectDeactivate.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="AddEditClientsIcon" runat="server" ImageUrl="~/Icons/edit.svg" CssClass="inline-img" />
                                    Dodaj/Uredi klijente
                                </h5>
                            </asp:HyperLink>
                        </div>
                    </div>
                </div>
                <!-- 3rd card end-->
            </div>
        </div>
        <footer>
            <hr />
            <p>
                &copy;App footer,
                <script>document.write(new Date().getFullYear()); </script>
            </p>
        </footer>
    </form>
</body>
</html>
