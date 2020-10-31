<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="MainProject.AdminDashboard" %>

<%@ Register Src="~/Components/NavBar.ascx" TagPrefix="uc1" TagName="NavBar" %>
<%@ Register Src="~/Components/Footer.ascx" TagPrefix="uc1" TagName="Footer" %>



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
        <uc1:NavBar runat="server" ID="NavBar" />
        <div class="container-fluid padding">
            <div class="row">
                <div class="col-12 greeting">
                    <h1 runat="server" id="h1Greeting">Pozdrav, direktore!</h1>
                </div>
            </div>
            <div class="row">
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
                        <asp:Image ID="EmployeeImage" runat="server" ImageUrl="~/Icons/work.svg" CssClass="card-img-top" />
                        <div class="card-body">
                            <h1 class="text-center card-inner-title">Zaposelnici</h1>
                            <asp:HyperLink ID="SelectEmployees" runat="server" NavigateUrl="SitesEmployee/EmployeeSelectDeactivate.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="SelectEmployeesIcon" runat="server" ImageUrl="~/Icons/user.svg" CssClass="inline-img" />
                                    Pregled zaposlenih
                                </h5>
                            </asp:HyperLink>
                            <asp:HyperLink ID="AddEmployee" runat="server" NavigateUrl="SitesEmployee/EmployeeAddUpdate.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="AddEmployeeIcon" runat="server" ImageUrl="~/Icons/add.svg" CssClass="inline-img" />
                                    Novi zaposlenik
                                </h5>
                            </asp:HyperLink>
                            <asp:HyperLink ID="EditEmployee" runat="server" NavigateUrl="SitesEmployee/EmployeeAddUpdate.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="EditEmployeeIcon" runat="server" ImageUrl="~/Icons/edit.svg" CssClass="inline-img" />
                                    Uredi zaposlene
                                </h5>
                            </asp:HyperLink>
                            <asp:HyperLink ID="DeactivateEmployee" runat="server" NavigateUrl="SitesEmployee/EmployeeSelectDeactivate.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="DeactivateEmployeeIcon" runat="server" ImageUrl="~/Icons/trash.svg" CssClass="inline-img" />
                                    Deaktiviraj zaposlene
                                </h5>
                            </asp:HyperLink>
                        </div>
                    </div>
                </div>
                <!-- 3rd card end-->
                <!-- 4th card start-->
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
                            <asp:HyperLink ID="ClientReports" runat="server" NavigateUrl="SitesReports/ClientReport.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="ClientReportsIcon" runat="server" ImageUrl="~/Icons/bar-chart.svg" CssClass="inline-img" />
                                    Izvještaji za klijente
                                </h5>
                            </asp:HyperLink>
                            <asp:HyperLink ID="SelectClients" runat="server" NavigateUrl="SitesClient/ClientSelectDeactivate.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="SelectClientsIcon" runat="server" ImageUrl="~/Icons/piggy-bank.svg" CssClass="inline-img" />
                                    Pregled klijenata
                                </h5>
                            </asp:HyperLink>
                            <asp:HyperLink ID="AddEditClients" runat="server" NavigateUrl="SitesClient/ClientAddUpdate.aspx" CssClass="card-title">
                                <h5 class="card-title">
                                    <asp:Image ID="AddEditClientsIcon" runat="server" ImageUrl="~/Icons/edit.svg" CssClass="inline-img" />
                                    Dodaj/Uredi klijente
                                </h5>
                            </asp:HyperLink>
                        </div>
                    </div>
                </div>
                <!-- 4th card end-->
            </div>
        </div>
        <uc1:Footer runat="server" id="Footer" />
    </form>
</body>
</html>
