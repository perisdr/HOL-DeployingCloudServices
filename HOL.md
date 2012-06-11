﻿<a name="HOLTop" />
# Deploying Cloud Services in Windows Azure #

---
<a name="Overview" />
## Overview ##

In this hands-on lab, you will learn how to deploy your first application in Windows Azure. The lab walks through the process using myTODO, a simple list creation and management application built using ASP.NET MVC. The lab shows the steps required for provisioning the required components in the Windows Azure Management Portal, uploading the service package, and configuring the service. You will see how you can test your application in a staging environment and then promote it to production once you are satisfied that it is operating according to your expectations.
 
![The myTODO application running in Windows Azure](images/mytodo.png?raw=true "The myTODO application running in Windows Azure")

_The myTODO application running in Windows Azure_


In the course of the lab, you will also examine how to deploy, upgrade, and configure Windows Azure applications programmatically using the Service Management API. You will use the Windows Azure Service Management Tools, which wraps the management API, to execute Windows PowerShell scripts that perform these operations. To complete the examination of deployment choices, you will use the Windows Azure Tools to deploy the application directly from Visual Studio.

During the lab, you will also learn how to provide an SSL connection to your Windows Azure service.

<a name="Objectives" />
### Objectives ###

In this hands-on lab, you will learn how to:

- Use the Windows Azure Management Portal to create a storage accounts and a cloud service
- Deploy service component packages using the Windows Azure Management Portal user interface
- Change configuration settings for a deployed application
- Test deployments in a separate staging environment before deployment to final production
- Use Windows PowerShell to deploy, upgrade, and configure Windows Azure services programmatically
- Use the Windows Azure Tools for publishing from Visual Studio
- Secure your Windows Azure application with SSL

<a name="Prerequisites" />
### Prerequisites ###

The following is required to complete this hands-on lab:

- [Microsoft .NET Framework 4.0][1]
- [Microsoft Visual Studio 2010][2]
- [ASP.NET MVC 4][3]
- [Windows Azure Tools for Microsoft Visual Studio 1.7][4]
- IIS 7 (with ASP.NET, WCF HTTP Activation)
- [Windows Azure PowerShell CmdLets][5]
- A Windows Azure subscription - you can sign up for free trial [here](http://bit.ly/WindowsAzureFreeTrial)

[1]: http://go.microsoft.com/fwlink/?linkid=186916
[2]: http://msdn.microsoft.com/vstudio/products/
[3]: http://www.asp.net/mvc/mvc4
[4]: http://www.microsoft.com/windowsazure/sdk/
[5]: http://msdn.microsoft.com/en-us/library/windowsazure/jj156055

> **Note:** This lab was designed to use Windows 7 Operating System.

<a name="Setup" />
### Setup ###

In order to execute the exercises in this hands-on lab you need to set up your environment.

1. Open a Windows Explorer window and browse to the lab’s **Source** folder.
2. Execute the **Setup.cmd** file with administrator privileges to launch the setup process that will configure your environment.
3. If the User Account Control dialog is shown, confirm the action to proceed.

> **Note:** When you first start Visual Studio, you must select one of the predefined settings collections. Every predefined collection is designed to match a particular development style and determines window layouts, editor behavior, IntelliSense code snippets, and dialog box options. The procedures in this lab describe the actions necessary to accomplish a given task in Visual Studio when using the **General Development Settings** collection. If you choose a different settings collection for your development environment, there may be differences in these procedures that you need to take into account.

---

<a name="Exercises" />
## Exercises ##

This hands-on lab includes the following exercises:

1. [Deploying an Application Using the Windows Azure Management Portal](#Exercise1)

1. [Using PowerShell to Manage Windows Azure Applications](#Exercise2)

1. [Using Visual Studio to Publish Applications](#Exercise3)

1. [Securing Windows Azure with SSL](#Exercise4)

Estimated time to complete this lab: **90 minutes**.

> **Note:** Each exercise is accompanied by a starting solution located in the Begin folder of the exercise that allows you to follow each exercise independently of the others. Please be aware that the code snippets that are added during an exercise are missing from these starting solutions and that they will not necessarily work until you complete the exercise. Inside the source code for an exercise, you will also find an End folder containing a Visual Studio solution with the code that results from completing the steps in the corresponding exercise. You can use these solutions as guidance if you need additional help as you work through this hands-on lab.


---

<a name="Exercise1" />
### Exercise 1: Deploying an application using the Windows Azure Management Portal ###

In this exercise, you deploy the myTODO application to Windows Azure using the Windows Azure Management Portal. To do this, you provision the required service components at the management portal, upload the application package to the staging environment and configure it. You then execute the application in this test environment to verify its operation. Once you are satisfied that it operates according to your expectations, you promote the application to production.


<a name="Ex1Task1" />
#### Task 1 – Creating a Storage Account and a Cloud Service ####

The application you deploy in this exercise requires a Cloud Service and a Storage Account. In this task, you create a new storage account to allow the application to persist its data. In addition, you define a Cloud Service to host your web application.

1. Navigate to [http://manage.windowsazure.com/](http://manage.windowsazure.com) using a Web browser and sign in using the Microsoft Account associated with your Windows Azure account.

	![Signing in to the Windows Azure Management portal](images/signing-in-to-the-windows-azure-platform-mana.png?raw=true)

	_Signing in to the Windows Azure Management portal_

1. First, you create an **Affinity Group** where your services will be deployed. In the Windows Azure menu, click **Networks**.

	![Networks](images/networks.png?raw=true "Networks")

	_Select Networks_

1. In the **Networks** page, click **Affinity Groups**.

	![Networks page](images/affinity-groups.png?raw=true "Networks page")

	_Networks page_

1. Click **Create** in order to create a new **Affinity Group**.

	![Create Affinity Group](images/create-affinity-group.png?raw=true "Create Affinity Group")

	_Create Affinity Group_

1. In the **Create Affinity Group** dialog, enter a **Name** (i.e. _MyAffinityGroup_), a **Description** and the **Region** for your new group. Then click the **Tick** to continue.

	![Affinity Group Details](images/affinity-group-details.png?raw=true "Affinity Group Details")

	_Affinity Group Details_

	>**Note:** The reason that you are creating a new affinity group is to deploy both the cloud service and storage account to the same location, thus ensuring high bandwidth and low latency between the application and the data it depends on.

1. Now, you will create the **Storage Account** that the application will use to store its data. In the Windows Azure Management Portal, click **New** | **Storage Account** | **Quick Create**.

1. Set a unique **URL**, for example _yournamemytodo_, select the _Affinity Group_ you previously created and click the **Tick** to continue.
 
	![Creating a new storage account](images/creating-a-new-storage-account.png?raw=true)

	_Creating a new storage account_

	> **Note:** The URL used for the storage account corresponds to a DNS name and is subject to standard DNS naming rules. Moreover, the name is publicly visible and must therefore be unique. The portal ensures that the name is valid by verifying that the name complies with the naming rules and is currently available. A validation error will be shown if you enter a name that does not satisfy the rules.
	>
	> ![URL Validation](images/url-validation.png?raw=true)

1. Wait until the Storage Account is created. Click your storage account's name to go to its **Dashboard**.

	![Storage Accounts page](images/storage-accounts-page.png?raw=true "Storage Accounts page")

	_Storage Accounts page_

1.	In the **Dashboard** page, you will see the **URL** assigned to each service in the storage account. Record the public storage account name, this is the first segment of the URL assigned to your endpoints.

	![Storage Account Dashboard page](images/storage-account-dashboard-page.png?raw=true "Storage Account Dashboard page")

	_Storage Account Dashboard page_

1.	Click **Manage Keys** at the bottom of the page in order to show the storage account's access keys.

	![Manage Storage Account Keys](images/manage-storage-account-keys.png?raw=true "Manage Storage Account Keys")

	_Manage Storage Account Keys_

1. Copy the **Primary access key** value. You will use this value later on to configure the application.

	![Retrieving the storage access keys](images/retrieving-the-storage-access-keys.png?raw=true)

	_Retrieving the storage access keys_

	>**Note:** The **Primary Access Key** and **Secondary** Access **Key** both provide a shared secret that you can use to access storage. The secondary key gives the same access as the primary key and is used for backup purposes. You can regenerate each key independently in case either one is compromised.

1. Next, create the **Cloud Service** that executes the application code. Click **New** | **Cloud Service** | **Quick Create**.

1.	Select a **URL** for your Cloud Service (e.g. _yournamemytodo_) and choose the **Affinity Group** where you created the Storage Account. Click the **Tick** to continue. Windows Azure uses the URL value to generate the endpoint URLs for the cloud service.

	![Creating a new Cloud Service](images/creating-a-new-cloud-service.png?raw=true "Creating a new Cloud Service")

	_Creating a new Cloud Service_

	>**Note:** If possible, choose the same name for both the storage account and cloud service. However, you may need to choose a different name if the one you select is unavailable.
	>
	>The portal ensures that the name is valid by verifying that the name complies with the naming rules and is currently available. A validation error will be shown if you enter name that does not satisfy the rules.
	>
	>![URL prefix validation](images/url-prefix-validation.png?raw=true)
	>
	> By choosing the same affinity group you used for your storage account, you ensure that the Cloud Service is deployed to the same data center.

1.	Wait until your Cloud Service is created to continue. Do not close the browser window, you will use the portal for the next task.

	![Cloud Service Created](images/cloud-service-created.png?raw=true "Cloud Service Created")

	_Cloud Service Created_

<a name="Ex1Task2" />
#### Task 2 – Publishing the Application to the Windows Azure Management Portal ####

A Cloud Service is a service that hosts your code in the Windows Azure environment. It has two separate deployment slots: staging and production. The staging deployment slot allows you to test your service in the Windows Azure environment before you deploy it to production. 

In this task, you create a service package for the myTODO application and then deploy it to the staging environment using the Windows Azure Management Portal.

1. Open **Microsoft Visual Studio 2010** with elevated administrator mode.

1. In the **File** menu, choose **Open** and then **Project/Solution**. In the **Open Project** dialog, browse to **Ex1-DeployingWithWAZPortal\Begin** in the **Source** folder of the lab, select **MyTodo.sln** and click Open.

	The solution contains the following projects:

	|        |        |
	|------------------|----------------|
	| MyTodo                   | A standard cloud service project configured to support a single web role named **MyTodo.WebUx**                         |
	| MyTodo.Data.WindowsAzure | A class library project that contains data contracts for the **MyTodo.WebUx** application for table storage |
	| AspProviders             | An implementation of ASP.NET Membership, Role, and SessionState providers for Storage in Windows Azure                             |
	| MyTodo.WebUx             | A web role that hosts the MyTODO ASP.NET MVC application in Windows Azure                                               |

1. Ensure that the **System.Web.Mvc** assembly is included in the service package that you deploy to Windows Azure.  To do this, expand the **References** node in **Solution Explorer** for the **MyTodo.WebUx** project, right-click the **System.Web.Mvc** assembly and select **Properties**. In the **Project Properties** window, switch to the **References** tab, select the **System.Web.Mvc** assembly, and press **F4**. 

	To add the assembly to the service package, in the **Properties** window for the **System.Web.Mvc** assembly, if **Copy Local** setting is set to _False_ then change it to _True_.

	![Including assemblies in the service package deployed to Windows Azure](images/including-assemblies-in-the-service-package-d.png?raw=true "Including assemblies in the service package deployed to Windows Azure")

	_Including assemblies in the service package deployed to Windows Azure_


	>**Note:** In general, you need to set **Copy Local = True** for any assembly that is not installed by default in the Windows Azure VMs to ensure that it is deployed with your application. 

1. Next, change the size of the virtual machine that will host the application. To do this, in **Solution Explorer**, expand the **Roles** node of the **MyTodo** project and then double-click the **MyTodo.WebUX** role to open its properties window. In the **Configuration** page, locate the **VM** Size setting under the **Instances** category and choose the **Extra small** size from the drop down list.
 	
	![Configuring the size of the virtual machine for the deployment](images/configuring-vm-depl-size.png?raw=true "Configuring the size of the virtual machine for the deployment")

	_Configuring the size of the virtual machine (VM) for the deployment_

	>**Note:** When you create your service model, you can specify the size of the virtual machine (VM) to which to deploy instances of your role, depending on its resource requirements. The size of the VM determines the number of CPU cores, the memory capacity, the local file system size allocated to a running instance, and the network throughput.

1. To configure the storage before deploying the service, open **ServiceConfiguration.cscfg** file located in **MyTodo** service. Replace the placeholder labeled \[YOUR\_ACCOUNT\_NAME\] with the **Storage Account Name** that you chose when you configured the storage account in Task 1. If you followed the recommendation, the name should follow the pattern **\<yourname\>mytodo**, where  \< _yourname_\>  is a unique name. Make sure to replace both instances of the placeholder, one for the _DataConnectionString_ and the second one for the _Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString_.

1. Next, replace the placeholder labeled \[YOUR\_ACCOUNT\_KEY\] with the **Primary Access Key** value that you recorded earlier, when you created the storage account in Task 1. Again, replace both instances of the placeholder, one for each connection string.

	![Configuring the storage account connection strings](images/configuring-storage-account-connection.png?raw=true "Configuring the storage account connection strings")

	_Configuring the storage account connection strings_

1. Now, define the version of the Windows Azure Guest Operating System that should run your service on the virtual machine. To do this, double-click the **ServiceConfiguration.cscfg** file in the **MyTodo** project to open this file in the XML editor. Now, add an **osVersion** attribute to the **ServiceConfiguration** root element and set its value to _WA-GUEST-OS-1.8\_201010\-01_, as shown in the figure below.

	>**Note:** The value used for **osVersion** here is to illustrate that you can select which release of the guest OS runs your application. You may use a higher version. 

	![Configuring which version of the guest operating system runs the application in the VM](images/configuring-guestOS.png?raw=true "Configuring which version of the guest operating system runs the application in the VM")

	_Configuring which version of the guest operating system runs the application in the VM_

	>**Note:** Windows Azure runs a guest operating system into which your service application will be deployed. This guest operating system is regularly updated. While rare, there is some chance that updated guest operating system versions may introduce breaking changes in your application. By setting the **osVersion** attribute, you ensure that your application runs in a version of the Windows Azure guest operating system that is compatible with the version of the Windows Azure SDK with which you developed it. You may then take the time to test each new **osVersion** prior to running it in your production deployment.
	
	>To configure the operating system version, you need to edit the service definition file directly because the current release of the Windows Azure Tools for Microsoft Visual Studio does not support setting this attribute through its user interface. 
	
	>Windows Azure offers an auto-upgrade feature, that automatically upgrades your service to use the latest OS version whenever it becomes available, thus ensuring that your service runs in an environment with the latest security fixes. This is the default mode if you omit an **osVersion** when you deploy your service. To change an existing service to auto-upgrade mode, set the **osVersion** attribute to the value "*".
	
	>For information on available versions of the Windows Azure guest operating system, see [Windows Azure Guest OS Versions and SDK Compatibility Matrix](http://msdn.microsoft.com/en-us/library/ee924680\(v=MSDN.10\).aspx).

1. Press **CTRL + S** to save the changes to the service model.

1. To create a service package, right-click the cloud service project and select **Package**. 

1. In the **Package Windows Azure Application** dialog, click **Package** and then wait until Visual Studio creates it. Once the package is ready, Visual Studio opens a window showing the folder that contains the generated files. Do not close this window, you will use the packages later in this task.

	![Creating a service package in Visual Studio](images/creating-a-service-package.png?raw=true "Creating a service package in Visual Studio")
	
	_Creating a service package in Visual Studio_

1.	At the portal, locate the Cloud Service you previously created and click its name in order to go to the **Dashboard** page.

1. Make sure **Staging** tab is selected and then click **Upload new staging deployment**.

	![Uploading the Application to Windows Azure](images/uploading-the-application-to-windows-azure.png?raw=true "Uploading the Application to Windows Azure")

	_Uploading the Application to Windows Azure_


	>**Note:** A Cloud Service is a service that runs your code in the Windows Azure environment. It has two separate deployment slots: staging and production. The staging deployment slot allows you to test your service in the Windows Azure environment before you deploy it to production.

1.	In the **Cloud Service - Upload Package** dialog click **Browse** to select a **Package location** and navigate to the folder where Visual Studio generated the package in the prior steps and then select **MyTodo.cspkg**.

	>**Note:** The _.cspkg_ file is an archive file that contains the binaries and files required to run a service - in this case it’s the Notification App Server ASP.NET MVC application. We used Visual Studio to create the service package for you using **Build | Publish** for the Windows Azure project.

1.	Now, to choose the **Configuration File**, click **Browse** and select **ServiceConfiguration.cscfg** file within the same folder.

	>**Note:** The _.cscfg_ file contains configuration settings for the application, including the instance count and configuration for **WNS** and the Storage account that you performed in the previous exercise.

1.	For the **Deployment Name**, enter a label to identify the deployment; for example, use _MyTodo-v1_.

	>**Note:** The management portal displays the label in its user interface for staging and production, which allows you to identify the version currently deployed in each environment.

1.	Finally, check **Deploy even if one or more roles contain a single instace**. Then click the **Tick** to start the deployment.

	![Configuring service package deployment](images/configuring-service-package-deployment.png?raw=true)

	_Configuring service package deployment_
 
1.	Notice that the package begins to upload and that the portal shows the status of the deployment to indicate its progress.

	![Uploading a service package to the Windows Azure Management Portal](images/uploading-a-service-package-to-the-windows-az.png?raw=true)

	_Uploading a service package to the Windows Azure Management Portal_

1. Wait until the deployment process finishes, which may take several minutes. At this point, you have already uploaded the package and it is in a **Ready** state. Notice that the portal assigned a **DNS name** to the deployment that includes a unique identifier. Shortly, you will access this URL to test the application and determine whether it operates correctly in the Windows Azure environment, but first you need to configure it.

	>**Note:** During deployment, Windows Azure analyzes the configuration file and copies the service to the correct number of machines, and starts all the instances. Load balancers, network devices and monitoring are also configured during this time.
 	
	![Package successfully deployed](images/package-successfully-deployed.png?raw=true "Package successfully deployed")

	_Package successfully deployed_

<a name="Ex1Task3" />
#### Task 3 – Configuring the Application to Increase Number of Instances ####

Before you can test the deployed application, you need to configure it. In this task, you change the service configuration already deployed to increase the number of instances.

1. In the **Windows Azure Management Portal**, go to **Cloud Services** page and click your **MyTodo** service name to open the service **Dashboard**.
 
	![Configuring application settings] (images/configuring-app-settings.png?raw=true "Configuring application settings")

	_Configuring application settings_

1. Click **Scale** in order to increase the number of roles your application has.

1. In the **Scale** page, make sure **Staging** tab is selected and update the number of roles to _2_.

	![Scaling Cloud Service](images/scaling-cloud-service.png?raw=true "Scaling Cloud Service")

	_Scaling Cloud Service_

 
	>**Note:** The initial number or roles is determined by the **ServiceConfiguration.cscfg** file that you uploaded earlier, when you deployed the package in Task 2.

	>**Note:** The **Instances** setting controls the number of roles that Windows Azure starts and is used to scale the service. For a token-based subscription—currently only available in countries that are not provisioned for billing—this number is limited to a maximum of two instances. However, in the commercial offering, you can change it to any number that you are willing to pay for.

1. Click **Save** to update the configuration and wait for the **Cloud Service** to apply the new settings.
 	
	![Updating the number of role instances](images/updating-number-role-instances.png?raw=true "Updating the number of role instances")
	
	_Updating the number of role instances_

	>**Note:** The portal displays a legend "Scale in progress..." while the settings are applied.


<a name="Ex1Task4" />
#### Task 4 – Testing the Application in the Staging Environment ####

In this task, you run the application in the staging environment and access its Web Site URL to test that it operates correctly.

1. In the **Cloud Services** page, go to your MyTodo service **Dashboard** and then click the **Site URL** link.

	![Running the application in the staging environment](images/running-app-staging.png?raw=true "Running the application in the staging environment")

	_Running the application in the staging environment_

	>**Note:** The address URL is shown as _\<guid\>.azurewebsites.net_, where \<_guid_\> is some random identifier. This is different from the address where the application will run once it is in production. Although the application executes in a staging area that is separate from the production environment, there is no actual physical difference between staging and production – it is simply a matter of where the load balancer is connected.
	
	>**Note:** In the future, you will be able to have multiple “virtual” areas, for test, QA, pre-production, etc... 

1. Click **Start** to prepare the application for first time use, which requires you to create a new account. To do this, navigate to register menu.
 	
	![Application running in the staging environment](images/application-running-staging.png?raw=true "Application running in the staging environment")

	_Application running in the staging environment_

1. Complete the account details by entering a user name, email address, and password and then click **Register**. 

	>**Note:**  Account information is stored in the storage account created earlier. Data is not shared between to do lists.

	![Application ready to be used](images/application-new-account.png?raw=true "Application ready to be used")
 
	_Creating a new account_

1. Next, the application enumerates the lists that you have currently defined. Since this is your first use, no lists should appear.

	![Application ready to be used](images/application-ready.png?raw=true "Application ready to be used")

	_Application ready to be used_

1. If you wish to explore the application, create a new TODO list and enter some items. 


<a name="Ex1Task5" />
#### Task 5 – Promoting the Application to Production ####

Now that you have verified that the service is working correctly in the staging environment, you are ready to promote it to final production.  When you deploy the application to production, Windows Azure reconfigures its load balancers so that the application is available at its production URL.

1. In **Cloud Services** page, click your MyTodo service **name** to open the **Dashboard**. Then click **Swap** within the bottom menu.
 
	![Promoting the application to the production slot](images/promoting-app-prod.png?raw=true "Promoting the application to the production slot")

	_Promoting the application to the production slot_

1. In the **VIP Swap** dialog, click **Yes** to swap the deployments between staging and production.
 
	![Promoting the application to the production deployment](images/promoting-app-deploy.png?raw=true "Promoting the application to the production deployment")
	
	_Promoting the application to the production deployment_

1. Once the Transition finishes, switch to **Production** tab and click the **Site URL** link to open the production site in a browser window and notice the URL in the address bar.
 
	![Application running in the production environment](images/application-running-production.png?raw=true "Application running in the production environment")

	_Application running in the production environment_


	>**Note:** If you visit the production site shortly after its promotion, the DNS name might not be ready. If you encounter a DNS error (404), wait a few minutes and try again. Keep in mind that Windows Azure creates DNS name entries dynamically and that the changes might take few minutes to propagate.

	>**Note:** Even when a deployment is in a suspended state, Windows Azure still needs to allocate a virtual machine (VM) for each instance and charge you for it. Once you have completed testing the application, you need to remove the deployment from Windows Azure to avoid an unnecessary expense. To remove a running deployment, go to your Cloud Service **Dashboard** page, select the deployment slot where the service is currently hosted, staging or production, and then click **Stop** on the bottom menu. Once the service has stopped, click **Delete** to remove it.


---

<a name="Exercise2" />
### Exercise 2: Using PowerShell to manage Windows Azure Applications ####

Typically, during its lifetime, an application undergoes changes that require it to be re-deployed. In the previous exercise, you saw how to use the Windows Azure Management Portal to deploy applications. As an alternative, the Service Management API provides programmatic access to much of the functionality available through the Management Portal. Using the Service Management API, you can manage your storage accounts and cloud services, your service deployments, and your affinity groups.

The Windows Azure Service Management PowerShell Cmdlets wrap the Windows Azure Service Management API. These cmdlets make it simple to automate the deployment, upgrade, and scaling of your Windows Azure application. By pipelining commands, you compose complex scripts that use the output of one command as the input to another.

In this exercise, you will learn how to deploy and upgrade a Windows Azure application using the Azure Services Management Cmdlets. 

<a name="Ex2Task1" />
#### Task 1 - Downloading and Importing a Publish-settings File ####

In this task, you will log on to the Windows Azure Portal and download the publish-settings file. This file contains the secure credentials and additional information about your Windows Azure Subscription to use in your development environment. Then, you will import this file using the Windows Azure Cmdlets in order to install the certificate and obtain the account information.

1.	Open an Internet Explorer browser and go to <https://manage.windowsazure.com/download/publishprofile.aspx>.

1.	Sign in using the Microsoft account associated with your Windows Azure account.

1.	**Save** the publish-settings file to your local machine.

	![Downloading publish-settings file](images/downloading-publish-settings-file.png?raw=true 'Downloading publish-settings file')

	_Downloading publish-settings file_

	> **Note:** The download page shows you how to import the publish-settings file using Visual Studio Publish box. This lab will show you both approaches, how to import it using the Windows Azure PowerShell Cmdlets or using Visual Studio Publish box.

1. In the start menu under **Start | All Programs | Windows Azure | Windows Azure PowerShell**, right-click **Windows Azure Powershell** and choose **Run as Administrator**.

1.	Change the PowerShell execution policy to **RemoteSigned**. When asked to confirm press **Y** and then **Enter**.
	
	<!-- mark:1 -->
	````PowerShell
	Set-ExecutionPolicy RemoteSigned
	````

	> **Note:** The Set-ExecutionPolicy cmdlet enables you to determine which Windows PowerShell scripts (if any) will be allowed to run on your computer. Windows PowerShell has four different execution policies:
	>
	> - _Restricted_ - No scripts can be run. Windows PowerShell can be used only in interactive mode.
	> - _AllSigned_ - Only scripts signed by a trusted publisher can be run.
	> - _RemoteSigned_ - Downloaded scripts must be signed by a trusted publisher before they can be run.
	> - _Unrestricted_ - No restrictions; all Windows PowerShell scripts can be run.
	>
	> For more information about Execution Policies refer to this TechNet article: <http://technet.microsoft.com/en-us/library/ee176961.aspx>

1.	The following script imports your publish-settings file and persists this information for later use. You will use these values during the lab to manage your Windows Azure Subscription. Replace the placeholder with your publish-setting file’s path and execute the script.

	<!-- mark:1 -->
	````PowerShell
	Import-AzurePublishSettingsFile '[YOUR-PUBLISH-SETTINGS-PATH]'
	````

1.  Execute the following commands to determine your subscription and storage account name.

	<!-- mark:1-2 -->
    ````PowerShell
    Get-AzureSubscription | select SubscriptionName
    Get-AzureStorageAccount | select StorageAccountName 
    ````

1.  Execute the following commands to set your current storage account for your subscription.

	<!-- mark:1 -->
	````PowerShell
	Set-AzureSubscription -SubscriptionName '[YOUR-SUBSCRIPTION-NAME]' -CurrentStorageAccount '[YOUR-STORAGE-ACCOUNT]' 
	````

<a name="anchor-name-here" />
#### Task 2 – Configuring the Application ####

In this task, you will configure the application using your Storage account information and generate a package to publish it using Windows Azure PowerShell CmdLets.

1. If it is not already open, launch Microsoft Visual Studio 2010 as administrator. To do this, in **Start | All Programs | Microsoft Visual Studio 2010**, right-click the **Microsoft Visual Studio 2010** shortcut and choose **Run as administrator**.

1. In the **File** menu, choose **Open** and then **Project/Solution**. In the **Open Project** dialog, browse to **Ex2-DeployingWithPowerShell\Begin** in the **Source** folder of the lab, select **MyTodo.sln** and click Open.

1. Configure the storage account connection strings. To do this, expand the **Roles** node in the **MyTodo** project and double-click the **MyTodo.WebUX** role. In the role properties window, select the **Settings** tab, select the _DataConnectionString_ setting, ensure that the **Type** is set to Connection String, and then click the button labeled with an ellipsis.
 
	![Defining storage account connection settings](images/defining-connection-settings.png?raw=true "Defining storage account connection settings")
	
	_Defining storage account connection settings_

1. In the **Storage Connection String** dialog, choose the **Enter storage credentials** option. Complete your storage **Account Name** and storage **Account Key** and click **OK**.
 
	![Configuring the storage account name and account key](images/defining-connection-settings-2.png?raw=true "Configuring the storage account name and account key")
	
	_Configuring the storage account name and account key_

	>**Note:** This information is available in the **Dashboard** section of your storage account in the Windows Azure Management Portal. You used the same settings in Exercise 1, when you deployed and configured the application. In that instance, because you were running the application in Windows Azure, you updated the configuration at the Management Portal. 

1. Repeat the previous steps to configure the _Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString_ setting using the same account information.

1. To create a service package, right-click the cloud service project and select **Package**. In the **Package Windows Azure Application** dialog, click **Package** and then wait until Visual Studio creates it. Once the package is ready, Visual Studio opens a window showing the folder that contains the generated files. Close the window after you see the package.
	
<a name="Ex2Task3" />
#### Task 3 – Uploading a Service Package Using Windows PowerShell ####

In the previous exercise, you uploaded the service package for the myTODO application using the Windows Azure Management Portal. In this task, you deploy the package using the Windows Azure Service Management PowerShell cmdlets instead. 

1. If not already open, open a Windows Azure PowerShell command prompt from **Start | All Programs | Windows Azure | Windows Azure PowerShell**.

1. Change the current directory to the location where you generated the service package for the myTODO application in the previous task. 

1. Next, enter the command shown below. Use the following command line arguments ensuring that you replace the parameter placeholders with the settings that apply to your service account.

	<!-- mark:1-5 -->
	````PowerShell
	$serviceName = '[YOUR-SERVICE-NAME-LOWER-CASE]'
	$packageLocation = '[PACKAGE-LOCATION]'
	$configurationLocation = '[CONFIGURATION-LOCATION]'
	$deploymentLabel = 'MyTodo-v2'
	New-AzureDeployment -ServiceName $serviceName -Package $packageLocation -Configuration $configurationLocation -Slot 'Staging' -Label $deploymentLabel -DoNotStart

	````
	|         |               |
	|---------|---------------|
	| [YOUR-SERVICE-NAME-LOWER-CASE]         | The service name chosen when configuring the cloud service URL in Exercise 1, not its Service Label |
	| [PACKAGE-LOCATION]                     | A path to a local file or the URL of the blob in your Storage Account that contains the service package.    |
	| [CONFIGURATION-LOCATION]               | A path to a local file or the public URL of the blob that contains the service configuration file.   |
	| [YOUR-DEPLOYMENT-LABEL] | The deployment label.|


	>**Note:** The command shown above uses the **New-AzureDeployment** cmdlet to upload a service package and create a new deployment in the staging environment. It assigns a "MyTodo-v2" label to identify this deployment.
	

	>**Important:** The **New-AzureDeployment** cmdlet assumes that the compute service and storage service names are the same. If this is not the case, specify an additional parameter -**StorageServicename \<YOUR_SERVICE_NAME_LOWER_CASE\>**, replacing the placeholder with the name of the storage service name.


	![New Azure Deployment Command Line](images/new-azure-deployment-command-line.png?raw=true "New Azure Deployment Command Line")
	
	_New-AzureDeployment Command Line_
	
	
1. Press **ENTER** to execute the command and wait until the **New-AzureDeployment** command finishes.
 
	![Deploying a new service package to Windows Azure using PowerShell](images/command-line-deploying-powershell.png?raw=true "Deploying a new service package to Windows Azure using PowerShell")

	_Deploying a new service package to Windows Azure using PowerShell_

1. In the Windows Azure Management Portal, open the Cloud Service's **Dashboard** page and notice how the deployment for the staging environment shows its status with the message "**Updating deployment...**" in the UI. It may take a few seconds for the service status to refresh. Wait for the deployment operation to complete and display the status as **Stopped**.


	![Deployment Stopped](images/deployment-stopped.png?raw=true "Deployment Stopped")
	
	_Deployment Stopped_

	>**Note:** Normally, you will not use the management portal to view the status and determine the outcome of your deployment operations. Here, it is shown to highlight the fact that you can use the management API to execute the same operations that are available in the management portal. In the next task, you will see how to use a cmdlet to wait for the operation to complete and retrieve its status.

1. Keep Microsoft Visual Studio and the PowerShell console open. You will need them for the next task.

<a name="Ex2Task4" />
#### Task 4 – Upgrading a Deployment Using Windows PowerShell ####

In this task, you use the Windows Azure PowerShell cmdlets to upgrade an existing deployment. First, you change the original solution by making minor changes to its source code to produce an updated version of the application. Next, you build the application and create a new service package that contains the updated binaries. Finally, using the management cmdlets, you re-deploy the package to Windows Azure. 

1. Go back to Microsoft Visual Studio. 

1. Open the layout view of the application for editing. To do this, in **Solution Explorer**, double-click **_Layout.cshtml** in the **Views\Shared** folder of the **MyTodo.WebUx** project. Switch to source mode.

1. Insert a new caption in the footer area of the page. Go to the bottom of the layout view and update the copyright notice with the text "(_Deployed with the PowerShell CmdLets_)" as shown below.

	<!-- mark:6 -->
	````HTML
	...
       </div>
       <div id="footer">
           <hr />
           <p class="copyright">
               &copy; 2012 Microsoft Corporation. All rights reserved. (Deployed with the PowerShell CmdLets)</p>
	    </div>
	      @RenderSection("ScriptsContent", required: false)
	    </div>
	</body>
	</html>
	````
	
1. Generate a new service package. To do this, in **Solution Explorer**, right-click the cloud service project and select **Package**. In the **Package Windows Azure Application** dialog, click **Package** and then wait until Visual Studio creates it. Once the package is ready, Visual Studio opens a window showing the folder that contains the generated files. 

1. Switch to the PowerShell console and enter the command shown below, specifying the settings that apply to your service account where indicated by the placeholder parameters. Do **not** execute the command yet.

	<!-- mark:1-4 -->
	````PowerShell
	$packageLocation = '[PACKAGE-LOCATION]'
	$configurationLocation = '[CONFIGURATION-LOCATION]'
	$deploymentLabel = 'MyTodo-v21'
	Get-AzureService -ServiceName $serviceName | Get-AzureDeployment -Slot staging | Set-AzureDeployment -Package $packageLocation -Configuration $configurationLocation -Upgrade -Label $deploymentLabel

	````

	>**Note:** The command line shown above concatenates a sequence of cmdlets. First, it obtains a reference to the cloud service using **Get-AzureService**, then it uses **Get-AzureDeployment** to retrieve its _staging_ environment, and finally it uploads the package using **Set-AzureDeployment**. This is done to illustrate how to compose a complex command using the PowerShell pipeline. In fact, in this particular case, you could instead provide all the required information to **Set-AzureDeployment** to achieve the same result. For example:
	
	>Set-AzureDeployment -Upgrade -ServiceName $serviceName -Package $packageLocation -Configuration $configurationLocation -Slot 'Staging' -Label $deploymentLabel 
	

1. Press **ENTER** to execute the command. Wait until the deployment process finishes, which may take several minutes. When the operation ends, it displays a message with the outcome of the operation; if the deployment completed without errors, you will see the message "Succeeded".

	![PowerShell console showing the status of the package deployment operation](images/command-line-powershell-status.png?raw=true "PowerShell console showing the status of the package deployment operation")
	
	_PowerShell console showing the status of the package deployment operation_

	>**Note:** Deploying a package using the steps described above does not change its state. If the service is not running prior to deployment, it will remain in that state. To start the service, you need to update its deployment status using the **Set-AzureDeployment** cmdlet.

1. To change the status of the service to a running state, in the **PowerShell** console, enter the following command.
PowerShell Console

	<!-- mark:1 -->
	````PowerShell
	Set-AzureDeployment -Status -ServiceName $serviceName -NewStatus 'Running' -Slot 'Staging'
	````
	
1. Finally, swap the deployments in the staging and production environments. To do this, in the **PowerShell** console, use the **Get-Deployment** and **Move-Deployment** cmdlets, as shown below.

	<!-- mark:1 -->
	````PowerShell
	Get-AzureService -ServiceName $serviceName | Get-AzureDeployment -Slot staging | Move-AzureDeployment
	````

<a name="Ex2Verification" />
#### Verification ####

Now that you have deployed your updated solution to Window Azure, you are ready to test it. You will launch the application to determine if the deployment succeeded and ensure that the service is working correctly and is available at its production URL. 

1. In your Cloud Service **Dashboard** page within the management portal, click the **Web Site URL** link to open the production site in a browser window. Notice the footer of the page. It should reflect the updated text that you entered in the last task.

	![New deployment showing the updated footer text](images/new-deployment.png?raw=true "New deployment showing the updated footer text")
	
	_New deployment showing the updated footer text_
	
	>**Note:** If you visit the production site shortly after its promotion, the DNS name might not be ready. If you encounter a DNS error (404), wait a few minutes and try again. Keep in mind that Windows Azure creates DNS name entries dynamically and that the changes might take few minutes to propagate.
	

---

<a name="Exercise3" />
### Exercise 3: Using Visual Studio to Publish Applications ####

Previously, you learnt how to deploy applications to Windows Azure using the Management Portal and a set of PowerShell cmdlets. If you are a developer, you may find it more convenient during your development cycle to deploy your applications directly from Visual Studio. 

The first time you publish a service to Windows Azure using Visual Studio, you need to create the necessary credentials to access your account. For doing this, you will use the PublishSettings file you downloaded in the previous exercise. 

Once you set up your account information in Visual Studio, you can publish your current solution in the background with only a few mouse clicks.

In this exercise, you set up the credentials to authenticate with the Windows Azure Management Service and then publish the MyTodo application from Visual Studio.


<a name="Ex3Task1" />
#### Task 1 – Preparing the Solution for Publish ####

When you publish your service using Visual Studio, the Windows Azure Tools upload the service package and then automatically start it. You will not have a chance to update the configuration settings before the service starts. Therefore, you must configure all the necessary settings before you publish the service.

In this task, you update the storage connection strings to point to your Storage Account.

1. Open Microsoft Visual Studio 2010 as administrator. To do this, in **Start | All Programs | Microsoft Visual Studio 2010**, right-click the **Microsoft Visual Studio 2010** shortcut and choose **Run as Administrator**. 

1. In the **File** menu, choose **Open** and then **Project/Solution**. In the **Open Project** dialog, browse to **Ex3-DeployingWithVisualStudio\Begin** in the **Source** folder of the lab, select **MyTodo.sln** and click **Open**.

	>**Note:** This is the same solution deployed earlier except for a legend in its footer area to indicate that it was deployed using **Visual Studio**.

1. In **Solution Explorer**, expand the **Roles** node inside the **MyTodo** cloud project and then double-click the **MyTodo.WebUx** role.

1. In the **MyTodo.WebUx \[Role\]** window, switch to the **Settings** tab and configure the necessary Storage account details replacing [YOUR\_ACCOUNT\_NAME] with the name of your storage account and [YOUR\_ACCOUNT\_KEY] with the shared key. Do this for both _DataConnectionString_ and _Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString_ settings. These are the same values that you used in previous exercises to configure the application.

1. Press **CTRL + S** to save your changes. 

<a name="Ex3Task2" />
#### Task 2 – Publishing a Service with the Windows Azure Tools ####

In this task, you will configure a set of credentials that provide access to your Windows Azure account. Visual Studio saves this information and allows you to reuse the credentials whenever you need to publish a service, without requiring you to enter your credentials again.

Then, you will use these credentials to publish the MyTODO application directly from Visual Studio.

1. In **Solution Explorer**, right-click the **MyTodo** cloud project and select **Publish**.

1. In the **Publish Windows Azure Application** dialog, click **Import**.

1. Browse to the PublishSettings file you dowloaded in the previous exercise, select it and click **Open**.

1. Back in the **Publish Windows Azure Application** dialog, select the subscription created from the _PublishSettings_ file and click **Next**.
 
	![Signing In](images/waz-sign-in.png?raw=true "Signing In")
	
	_Signing In_

1. In the **Common Settings** tab, notice that the dialog populates the drop down list labeled **Cloud Service** with the information for all the services configured in your Windows Azure account. Select the cloud service in this list where you wish to deploy the application.

1. Make sure the **Environment** is set to _Production_ and the **Build Configuration** to _Release_. Also, set the **Service Configuration** with _default_ value.
 
	![Deployment Common Settings](images/deployment-common-settings.png?raw=true "Deployment Common Settings")
	
	_Deployment Common Settings_

1. Click **Advanced Settings** tab. Update the **Deployment Label** to _MyTodo_ and check the check box labeled **Append date and time** to identify the deployment in the Developer Portal UI.

1. Like with the Cloud Services, the dialog populates the drop down list labeled **Storage account** with all the storage services that you have configured in your Windows Azure account. To publish a service, Visual Studio first uploads the service package to storage in Windows Azure, and then publish the service from there. Select the storage service that you wish to use for this purpose and click **Next**.
 
	![Deployment Advanced Settings](images/deployment-advanced-settings.png?raw=true "Deployment Advanced Settings")
	
	_Deployment Advanced Settings_

	>**Note:** Although this is not covered in this lab, the IntelliTrace option enables you to capture detailed trace logs of your running service in the cloud that you can download to your desktop to perform historical debugging. This can be invaluable when troubleshooting issues that occur during role start up. Note that IntelliTrace requires the .NET Framework 4 and it is only available in Visual Studio Ultimate edition.

1. Review the Summary information. If everything is OK, click **Publish** to start the deployment process.
 
	![Starting Deployment](images/start-deployment.png?raw=true "Starting Deployment")

	_Starting Deployment_

	>**Note:** At the top of the dialog, you will find a Target Profile drop down list. Once you configured your deployment settings, you can save them as a new profile and use it later without having to complete all the fields again.

1. If the slot that you chose is already occupied by a previous deployment, Visual Studio warns you and asks for confirmation before it replaces it. Click **Replace** if you are certain that the current deployment is no longer needed and can be overwritten. Otherwise, click **Cancel** and repeat the operation choosing a different deployment slot.

	![Overwriting an existing deployment](images/overwrite-existing-deployment.png?raw=true)
	
	_Overwriting an existing deployment_

1. After you start a deployment, you can examine the Windows Azure activity log window to determine the status of the operation. If this window is not visible, in the **View** menu, point to **Other Windows**, and then select **Windows Azure Activity Log**.

1. By default, the log shows a descriptive message and a progress bar to indicate the status of the deployment operation. 
 
	![Viewing summary information in the Windows Azure activity log](images/waz-activity-summary.png?raw=true "Viewing summary information in the Windows Azure activity log")
	
	_Viewing summary information in the Windows Azure activity log_

1. To view detailed information about the deployment operation in progress, double-click the green arrow on the left side of the activity log entry.
Notice that the additional information provided includes the deployment slot, **Production** or **Staging**, the **Website URL**, the **Deployment ID**, and a **History** log that shows state changes, including the time when each change occurred. 
 
	![Viewing detailed information about a deployment operation](images/detailed-deployment-information.png?raw=true "Viewing detailed information about a deployment operation")
	
	_Viewing detailed information about a deployment operation_

1. Wait for the deployment operation to complete, which may take several minutes. While this is happening, you can examine the **History** panel on the right side to determine the status of the deployment. For a successful deployment, it should resemble the following sequence.
 
	![Deployment operation history log](images/deployment-operation-log.png?raw=true "Deployment operation history log")
	
	_Deployment operation history log_

1. Once the deployment operation is complete, in the **Windows Azure Activity Log**, click the **Website URL** link for the completed operation to open the application in your browser and ensure that it is working properly. Notice the legend in the copyright notice at the bottom of the page indicating that this is the version that you deployed with Visual Studio.
 
	![Running the application deployed with Visual Studio](images/running-deployment.png?raw=true "Running the application deployed with Visual Studio")
	
	_Running the application deployed with Visual Studio_

---

<a name="Exercise4" />
### Exercise 4: Securing Windows Azure with SSL ###

In this exercise, you enable SSL to secure the myTODO application. This involves creating a self-signed certificate for server authentication and uploading it to the Windows Azure portal. With the certificate in place, you add a new HTTPS endpoint to the service model and assign the certificate to this endpoint.  You complete the exercise by deploying the application to Windows Azure one more time and then access it using its HTTPS endpoint.

<a name="Ex4Task1" />
#### Task 1 – Adding an HTTPS Endpoint to the Application ####

In this task, you update the service model of MyTODO to add an HTTPS endpoint and then you test the application in the compute emulator.

1. If not already open, launch Microsoft Visual Studio 2010 in elevated administrator mode. To do this, in **Start | All Programs | Microsoft Visual Studio 2010**, right-click the **Microsoft Visual Studio 2010** shortcut and choose **Run as administrator**. 

1. In the **File** menu, choose **Open** and then **Project/Solution**. In the **Open Project** dialog, browse to **Ex4-SecuringAppWithSSL\Begin** in the **Source** folder of the lab, select **MyTodo.sln** and click **Open**.

1. Expand the **Roles** node in the **MyTodo** project, and then double-click the **MyTodo.WebUx** role to open its properties window.

1. In the **MyTodo.WebUx \[Role\]** window, switch to the **Settings** tab and configure the necessary Storage account details replacing [YOUR\_ACCOUNT\_NAME] with the name of your storage account and [YOUR\_ACCOUNT\_KEY] with the shared key. Do this for both _DataConnectionString_ and _Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString_ settings. These  are the same values that you used in previous exercises to configure the application. Remember to set the Type to Connection String for the both settings after leaving this screen.

1. Next, switch to the **Endpoints** tab and select the **HTTPS** option, fill Public Port with the value 443 and leave the **Name** field unchanged. Do not choose an SSL certificate at this time; you will do so later in the exercise.
 
	![Adding an HTTP endpoint to the application](images/adding-http-endpoint.png?raw=true "Adding an HTTP endpoint to the application")
	
	_Adding an HTTP endpoint to the application_

1. Now, choose the HTTPS endpoint as the one to use when you launch the application in the browser when you are debugging it. To do this, right-click the **MyTodo.WebUx** role in the **MyTodo** project, point to **Launch in Browser**, and then ensure that only **HTTPS** is selected.
 
	![Choosing the endpoint used to debug the application](images/choosing-debug-endpoint.png?raw=true "Choosing the endpoint used to debug the application")
	
	_Choosing the endpoint used to debug the application_

1. You will now test the application locally. Press **F5** to build and launch the application in the compute emulator. Notice that the browser indicates that there is a problem with the certificate. Ignore the warning and click **Continue to this website**.
 
	![Certificate error when testing in the compute emulator](images/certificate-error-computer-emulator.png?raw=true "Certificate error when testing in the compute emulator")
	
	_Certificate error when testing in the compute emulator_

	>**Note:** When testing your application in the local development environment using SSL, you do not need to configure a certificate. Instead, the compute emulator handles this requirement by using its own certificate. However, the certification authority for the certificate that it uses is not trusted, hence the warning. You may safely ignore the warning while you test your application locally.
	
	>If you wish, you can remove the warning by installing the certificate in the **Trusted Root Certification Authorities** certificate store. Note, however, that this has security implications that you need to evaluate before you proceed.
	
	>To remove the warning, open the **Microsoft Management Console**, add an instance of the **Certificates** snap-in and configure it to manage certificates for the **Computer** account. Expand the **Personal\Certificates** store and locate a certificate issued to 127.0.0.1. To ensure that you have the right certificate, view its properties to verify that the **Subject** and **Issuer** fields identify the certificate as belonging to the compute emulator. To trust the certificate, simply drag and drop the certificate from the **Personal** certificate store into the **Trusted Root Certification Authorities** certificate store.
	
	> ![Certificate used by the compute emulator to implement SSL](images/computer-emulator-certificate.png?raw=true "Certificate used by the compute emulator to implement SSL")
	>
	>_Certificate used by the compute emulator to implement SSL_

1. After you access the home page, notice that the address bar shows that you are now accessing the HTTPS endpoint.
 
	![Accessing the HTTPS endpoint in the compute emulator](images/accessing-endpoints.png?raw=true "Accessing the HTTPS endpoint in the compute emulator")

	_Accessing the HTTPS endpoint in the compute emulator_

1. Close the browser window. You will now create a self-signed certificate and deploy the application to Windows Azure.

1. Do not close the project in Visual Studio. You will need it shortly.

<a name="Ex4Task2" />
#### Task 2 – Creating a Self-Signed Certificate ####

In this task, you create a self-signed certificate that you can upload to the Windows Azure Developer Portal to configure an SSL endpoint for your application.

>**Note:** if you are unable to use Internet Information Services (IIS) Manager in your environment, you may skip this task. Instead, you can find a self-signed certificate that you can use among the lab’s resources.

>To install the certificate, open Windows Explorer, browse to **Assets** in the **Source** folder of the lab and then double-click the **YourNameToDo.pfx** file to install the certificate using the **Certificate Import Wizard**. Use "password1" (without the quotation marks) as the password. Use default values for all other options.

>**Important:** You should only use this certificate to complete the steps in the exercise. Do not use the certificate in your production deployments.


1. Start Internet Information Services Manager. To do this, click the **Start** button and type "iis" in the search box and then click **Internet Information Services (IIS) Manager** in the list of installed programs.
 
	![Launching Internet Information Services (IIS) Manager](images/iis-manager-launch.png?raw=true "Launching Internet Information Services \(IIS\) Manager")
	
	_Launching Internet Information Services (IIS) Manager_

1. In the **Connections** pane of the Internet Information Services (IIS) Manager console, select the top-level node corresponding to your computer. Next, locate the **IIS** category in the middle pane and double-click **Server Certificates**.
 
	![Managing certificates with Internet Information Services (IIS) Manager](images/iis-managing-certificates.png?raw=true "Managing certificates with Internet Information Services \(IIS\) Manager")

	_Managing certificates with Internet Information Services (IIS) Manager_

1. In the **Server Certificates** page, click **Create Self-Signed Certificate** in the **Actions** pane.
 
	![Creating a self-signed certificate in the Internet Information Services (IIS) Manager](images/iis-creating-self-signed-certificate.png?raw=true "Creating a self-signed certificate in the Internet Information Services \(IIS\) Manager")

	_Creating a self-signed certificate in the Internet Information Services (IIS) Manager_

1. In the **Specify Friendly Name** page of the **Create Self-Signed Certificate** wizard, enter a name to identify your certificate—this can be any name, for example, **\<yourname\>MyToDo**, where you replace the placeholder with your name—and then click **OK**.
 
	![Specifying a name for the certificate](images/iis-specifying-certificate-name.png?raw=true "Specifying a name for the certificate")
	
	_Specifying a name for the certificate_

1. Now, right-click the newly created certificate and select **Export** to store the certificate in a file. 
 
	![Server certificates page showing the new self-signed certificate](images/iis-server-certificates.png?raw=true "Server certificates page showing the new self-signed certificate")
	
	_Server certificates page showing the new self-signed certificate_

1. In the **Export Certificate** dialog, enter the name of a file in which to store the certificate for exporting, type a password and confirm it, and then click **OK**. Make a record of the password. You will require it later on, when you upload the certificate to the portal.
 
	![Exporting the certificate to a file](images/iis-exporting-certificate.png?raw=true)
	
	_Exporting the certificate to a file_

<a name="Ex4Task3" />
#### Task 3 – Adding the Certificate to the Service Model of the Application ####

Previously, when you tested SSL access to the application in your local environment, you were able to do so without specifying a certificate by taking advantage of the certificate managed by the compute emulator. In this task, you configure the application to use the self-signed certificate that you created in Internet Information Services (ISS) Manager.

1. Switch back to Visual Studio. If you closed the project, you will need to reopen it from **Ex4-SecuringAppWithSSL\Begin** in the **Source** folder of the lab.

1. In **Solution Explorer**, expand the **Roles** node in the **MyTodo** project, double-click the **MyTodo.WebUx** role to open its properties window, and then switch to the **Certificates** tab.

1. In the **Certificates** page, click **Add Certificate**. Complete the **Name** field with a value that identifies the certificate that you are adding, for example, use _SSL_. Ensure that the **Store Location** is set to _LocalMachine_ and the **Store Name** is set to _My_ and then click the button labeled with an ellipsis, to the right of the **Thumbprint** column.

1. In the **Select a certificate** dialog, select the self-signed certificate that you created earlier and then click **OK**. 
	
	![Choosing a certificate for the service](images/selecting-certificate.png?raw=true "Choosing a certificate for the service")
	
	_Choosing a certificate for the service_

1. Notice that the dialog populates the **Thumbprint** column with the corresponding value from the certificate.  
 

	![Adding a certificate to the service model of the application](images/adding-certificate-service-model.png?raw=true "Adding a certificate to the service model of the application")
	
	_Adding a certificate to the service model of the application_

1. Now, switch to the **Endpoints** tab and, in the **HTTPS** input endpoints section, expand the **SSL certificate name** drop down list and select the certificate that you added to the service in the previous step.
 
	![Choosing a certificate to use for the HTTPS endpoint](images/choosing-certificate-https-endpoint.png?raw=true "Choosing a certificate to use for the HTTPS endpoint")
	
	_Choosing a certificate to use for the HTTPS endpoint_

1. Press **CTRL+S** to save the changes to the configuration.


<a name="Ex4Task4" />
#### Task 4 – Uploading the Certificate to the Windows Azure Management Portal ####

In this task, you upload the self-signed certificate created in the previous step to the Windows Azure Management Portal.

1. Navigate to [http://manage.windowsazure.com/](http://manage.windowsazure.com) using a Web browser and sign in using your Microsoft account.

1. In the **Cloud Services** page, click your cloud service's **name** to go to the service's **Dashboard**.

1. Click **Certificates** and then **Upload a certificate**.

	![Adding a new Certificate](images/adding-a-new-certificate.png?raw=true "Adding a new Certificate")

	_Adding a new Certificate_

1. In the **Upload Certificate** dialog, click **Browse**, and then navigate to the location where you stored the certificate exported in the previous task. Enter the password that specified when you exported the certificate, confirm it and then click the **Tick**.
 
	![Creating a certificate for the service](images/creating-certificate-service.png?raw=true "Creating a certificate for the service")
	
	_Creating a certificate for the service_

<a name="Ex4Verification" />
#### Verification ####

In this task, you deploy the application to Windows Azure and access its HTTPS endpoint to verify that your enabled SSL successfully.

1. Publish and deploy the application once again to the Windows Azure environment using your preferred method, by choosing among the Windows Azure Developer Portal, the Windows Azure Service Management PowerShell Cmdlets, or the Windows Azure Tools for Visual Studio. Refer to Exercises 1, 2, and 3 for instructions on how to carry out the deployment with any of these methods.

	>**Note:** The service configuration now specifies an additional endpoint for HTTPS, therefore, you cannot simply upgrade the current deployment and instead, you need to re-deploy the application. This is mandatory whenever you change the topology of the service.

1. Once you have deployed the application, start it and wait until its status is shown as **Ready** (or the deployment is shown as **Completed** when deploying with Visual Studio).

1. Now, browse to the HTTPS endpoint (e.g. _https://yournametodo.azurewebsites.net_). Once again, you will observe a certificate error because the certificate authority for the self-signed certificate is not trusted. You may ignore this error.
 
	![Accessing the HTTPS endpoint in Windows Azure](images/accessing-https-endpoint.png?raw=true "Accessing the HTTPS endpoint in Windows Azure")
	
	_Accessing the HTTPS endpoint in Windows Azure_

	>**Note:** For your production deployments, you can purchase a certificate for your application from a trusted authority and use that instead.


<a name="Ex4Task5" />
#### Task 5 – Configuring a CNAME Entry for DNS Resolution (Optional) ####

When you deploy your application, the Windows Azure fabric assigns it a URL of the form _http://\[yournametodo\].azurewebsites.net_, where [_yournametodo_] is the public name that you chose for your cloud service at the time of creation. While this URL is completely functional, there are many reasons why you might prefer to use a URL in your own domain to access the service. In other words, instead of accessing the application as _http://yournametodo.azurewebsites.net_, use your own organization's domain name instead, for example _http://yournametodo.fabrikam.com_.

One way to map the application to your own domain is to set up a CNAME record in your own DNS system pointing at the host name in Azure. A CNAME provides an alias for any host record, including hosts in different domains. Thus, to map the application to the _fabrikam.com_ domain, you can create the following record in your DNS.

| **Organization's domain**     | **Alias**   | **Application's domain**       |
|---------------------------|---------|----------------------------|
| yournametodo.fabrikam.com | CNAME   | yournametodo.azurewebsites.net  |


The procedure for doing this varies depending on the details of your DNS infrastructure. For external domain registrars, you can consult their documentation to find out the correct procedure for setting up a CNAME. For additional information on this topic, see [Custom Domain Names in Windows Azure](http://blog.smarx.com/posts/custom-domain-names-in-windows-azure).
As an example, this task briefly shows how you set up an alias using Microsoft DNS on Windows Server 2008. 

>**Note:** Windows DNS Server should be installed on the Windows Server 2008. You can enable the DNS Server role on the Server Manager.

1. Open DNS Manager from **Start | Administrative Tools | DNS**.

1. In DNS Manager, expand the **Forward Lookup Zones** node, then right-click the zone where you intend to set up the alias and select **New Alias (CNAME)**.Notice that if you do not have any zone, you must create one prior the alias creation.
 
	![Updating a lookup zone to create an alias](images/creating-alias.png?raw=true "Updating a lookup zone to create an alias")
	
	_Updating a lookup zone to create an alias_

1. In the **New Resource Record** dialog, enter the alias name that you would like to use to access the application hosted in Azure, for example, _yournametodo_. Then, type in the fully qualified domain name of your application that Azure assigned to your application, for example, _\[yournametodo\].azurewebsites.net_. Click **OK** to create the record.
 
	![Creating an alias for the myTODO application in Azure](images/creating-alias-app.png?raw=true "Creating an alias for the myTODO application in Azure")
	
	_Creating an alias for the myTODO application in Azure_

1. In the DNS Manager console, review the contents of the updated zone to find the newly created CNAME record.
 
	![Updated lookup zone showing the new alias for the application](images/lookup-zone-alias.png?raw=true "Updated lookup zone showing the new alias for the application")
	
	_Updated lookup zone showing the new alias for the application_

1. Now, open a command prompt and type the following command to verify that the alias is set up correctly and maps to the address of the application in Windows Azure. 

	<!--mark: 1-->
	````CommandPrompt
	nslookup <youralias>
	````
 
	![Verifying the domain alias](images/command-prompt-alias-verification.png?raw=true "Verifying the domain alias")

	_Verifying the domain alias_
	

	You will now be able to access the application using the alias.

---

<a name="Summary" />
## Summary ##

By completing this hands-on lab, you learnt how to create a storage account and a cloud service at the Windows Azure Management Portal. Using the management portal, you deployed a service package that contained the application binaries, configured its storage and defined the number of instances to run. 

You also saw how to achieve this programmatically using the Service Management API and in particular, how to use the Windows Azure Service Management cmdlets to deploy, update, and manage applications using Windows PowerShell.

As a developer, you saw how to use Windows Azure Tools in Visual Studio to publish your solution in the background, while you continue with your development tasks.
Finally, you learnt how to upload certificates using the management portal and use SSL to secure your Windows Azure application.