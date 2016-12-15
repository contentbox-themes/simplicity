/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A theme is composed of the following pieces
* 
* /ThemeDirectory
*  + Theme.cfc (The CFC that models your theme implementation)
*  / layouts (The folder that contains layouts in your theme)
*    + blog.cfm (Mandatory layout used for all blog views by convention)
*    + pages.cfm (Mandatory layout used for all pages by convention)
*    + maintenance.cfm (Optional used when in maintenance mode, else defaults to pages)
*    + search.cfm (Optional used when doing searches, else defaults to pages)
*  / views (The folder that contains views for rendering)
*  	 + archives.cfm (MANDATORY: The view used to render out blog archives.)
*  	 + entry.cfm (MANDATORY: The view used to render out a single blog entry with comments, etc.)
*  	 + error.cfm (MANDATORY: The view used to display errors when they ocurr in your blog or pages)
*  	 + index.cfm (MANDATORY: The view used to render out the home page where all blog entries are rendered)
*  	 + notfound.cfm (The view used to display messages to users when a blog entry requested was not found in our system.)
*  	 + page.cfm (MANDATORY: The view used to render out individual pages.)
*  	 + maintenance.cfm (OPTIONAL: Used when in maintenance mode)
* / templates (The folder that contains optional templates for collection rendering that are used using the quick rendering methods in the CB Helper)
* 	 + category.cfm (The template used to display an iteration of entry categories using coldbox collection rendering)
* 	 + comment.cfm (The template used to display an iteration of entry or page comments using coldbox collection rendering)
* 	 + entry.cfm (The template used to display an iteration of entries in the home page using coldbox collection rendering)
* / widgets (A folder that can contain layout specific widgets which override core ContentBox widgets)
* 
* Templates
* Templates are a single cfm template that is used by ContentBox to iterate over a collection (usually entries or categories or comments) and
* render out all of them in uniformity.  Please refer to ColdBox Collection Rendering for more information.  Each template recevies
* the following:
* 
* _counter (A variable created for you that tells you in which record we are currently looping on)
* _items (A variable created for you that tells you how many records exist in the collection)
* {templateName} The name of the object you will use to display: entry, comment, category
*
* Layout Local CallBack Functions:
* onActivation()
* onDelete()
* onDeactivation()
* 
* Settings
* You can declare settings for your layouts that ContentBox will manage for you.
* 
* this.settings = [
* 	{ name="Title", defaultValue="My Awesome Title", required="true", type="text", label="Title:" },
* 	{ name="Colors", defaultValue="blue", required="false", type="select", label="Color:", options="red,blue,orange,gray" }
* ];
* 
* The value is an array of structures with the following keys:
* 
* - name : The name of the setting (required), the setting is saved as cb_layoutname_settingName
* - defaultValue : The default value of the setting (required)
* - required : Whether the setting is required or not. Defaults to false
* - type : The type of the HTMl control (text=default, textarea, boolean, select)
* - label : The HTML label of the control (defaults to name)
* - title : The HTML title of the control (defaults to empty string)
* - options : The select box options. Can be a list or array of values or an array of name-value pair structures
* 
*/
component{
 	
 	property name="settingService"	inject="id:settingService@cb";
 	property name="menuService" 	inject="id:MenuService@cb";
 	property name="categoryService" inject="id:CategoryService@cb";
 	property name="pageService" 	inject="id:PageService@cb";
 	 
	// Layout Variables
    this.name       	= "ContentBox Simplicity Theme";
	this.description 	= "ContentBox Simplicity layout for ContentBox 3 based on Bootstrap 3";
    this.version        = "@build.version@+@build.number@";
	this.author 		= "Ortus Solutions";
	this.authorURL		= "https://www.ortussolutions.com";
	// Screenshot URL, can be absolute or locally in your layout package.
	this.screenShotURL	= "screenshot.png";
	
	
	function onDIComplete( ){
		
		// Layout Settings
		this.settings = [
			{ name="cbBootswatchTheme", 	group="Colors", defaultValue="corporate", 	type="select", 		label="ContentBox Swatch Theme:", 	required="false", options="corporate,teetime,green-blue" },
			{ name="headerLogo", 			group="Header", defaultValue="", 		type="text", 	label="Logo URL:" },
			{ name="headerMainNav", 		group="Header", defaultValue="none", 		type="select", 	label="Main Navigation:", options="none,#menus()#"},
	
			{ name="locAddress", 			group="Location", defaultValue="", 		type="text", 	label="Address:" },
			{ name="locCity", 				group="Location", defaultValue="", 		type="text", 	label="City:" },
			{ name="locState", 				group="Location", defaultValue="", 		type="text", 	label="State:" },
			{ name="locZip", 				group="Location", defaultValue="", 		type="text", 	label="Zip:" },
			{ name="locPhone", 				group="Location", defaultValue="", 		type="text", 	label="Phone:" },
			{ name="locEmail", 				group="Location", defaultValue="", 		type="text", 	label="Email:" },
			
			{ name="sec2Category", 			group="Stacked Pages", defaultValue="none", 	type="select", 		label="Page Category:", options="none,#entryCategories()#" },
			{ name="sec2ActivateMenu", 		group="Stacked Pages", defaultValue="no", 		type="select", 		label="Activate One Page Menu:", options="no,yes" },
			
			{ name="rssDiscovery", 			group="Homepage", 	defaultValue="true", 	type="boolean",		label="Active RSS Discovery Links", 	required="false" },
			{ name="showCategoriesBlogSide", 	group="Blog Sidebar Options", defaultValue="true", type="boolean",		label="Show Categories in Blog Sidebar", 	required="false" },
			{ name="showRecentEntriesBlogSide", group="Blog Sidebar Options", defaultValue="true", type="boolean",	label="Show Recent Enties in Blog Sidebar", 	required="false" },
			{ name="showSiteUpdatesBlogSide", 	group="Blog Sidebar Options", defaultValue="true", type="boolean",	label="Show Site Updates in Blog Sidebar", 	required="false" },
			{ name="showEntryCommentsBlogSide", group="Blog Sidebar Options", defaultValue="true", type="boolean",	label="Show Entry Comments in Blog Sidebar", 	required="false" },
			{ name="showArchivesBlogSide", 		group="Blog Sidebar Options", defaultValue="true", type="boolean",	label="Show Archives in Blog Sidebar", 	required="false" },
			{ name="showEntriesSearchBlogSide", group="Blog Sidebar Options", defaultValue="true", type="boolean",	label="Show Entries Search in Blog Sidebar", 	required="false" },
			
			{ name="socialFB", 		group="Social", defaultValue="", 		type="text", 	label="Facebook:" },
			{ name="socialIG", 		group="Social", defaultValue="", 		type="text", 	label="Instagram:" },
			{ name="socialT", 		group="Social", defaultValue="", 		type="text", 	label="Twitter:" },
			{ name="socialGP", 		group="Social", defaultValue="", 		type="text", 	label="Google+:" },
			{ name="socialYT", 		group="Social", defaultValue="", 		type="text", 	label="YouTube:" }
			
		];
		return this;
	}
	/**
	* Call Back when layout is activated
	*/
	function onActivation(){
	
	}

	/**
	* Call Back when layout is deactivated
	*/
	function onDeactivation(){

	}

	/**
	* Call Back when layout is deleted from the system
	*/
	function onDelete(){

	}
	
	/**
	* After saving theme generate required settings
	*/
	function cbadmin_postThemeSettingsSave(event, interceptData, buffer){
		generatePageContentStackFields();
	}
	
	/**
	* Generates the custom fields for the Page Content Stack Widget
	*/
	private function generatePageContentStackFields(){
		var aFieldKeys 			= [ "bgColor", "alignment","vcenter" ];
		var pageSectionCatName 	= settingService.getSetting("cb_theme_#settingService.getSetting( 'cb_site_theme' )#_sec2Category");
		
		// is there a category selected
		if( pageSectionCatName != "none" ){
			var oCategory = categoryService.findWhere( criteria={category=pageSectionCatName} );
			var sPages = pageService.search( category=oCategory.getCategoryID(), sortOrder="order" );
			
			for ( var page in sPages.pages ) {
				var sfields = page.getCustomFieldsAsStruct();
					
				for ( var field in aFieldKeys ) {
			
					// if page does not have field	
					if( !structKeyExists( sfields, field  ) ){
							
						// create field
						transaction{
							var newCustomField = EntityNew( 'cbCustomField' );
							newCustomField.setKey( field );
							newCustomField.setValue( "" );
							newCustomField.setRelatedContent( page );
								
							EntitySave( entity=newCustomField );
						}
					}
				}		
			}
			
			// generate one page menu
			generateOnePageMenu( sPages );
		}
	}
	
	/**
	* Generates the One Page Menu based on the pages
	* @pages the pages which the menu will be linking
	*/
	private function generateOnePageMenu( struct pages ){
		var isActive	= settingService.getSetting("cb_theme_#settingService.getSetting( 'cb_site_theme' )#_sec2ActivateMenu");
		var menuSlug 	= "pcs-one-page-menu";
		var menuTitle 	= "PCS One Page Menu";
		var menuClass	= "nav navbar-nav navbar-spy";
		
		// is setting set to activate single page menu? 
		if( isActive == "yes"){
			
			// find the menu by the slug
			var oMenu = menuService.findBySlug( menuSlug );
			
			if( isNull( oMenu.getMenuID() ) ){
				
				//create menu 
				oMenu.setTitle( menuTitle );
				oMenu.setSlug( menuSlug );
				oMenu.setMenuClass( menuClass );
				
				menuService.save( oMenu );
			}
			
			// get the menu items
			var sMenuItems = oMenu.getMenuItems();
			
			for( var page in pages.pages ) {
				var pageTitle = page.getTitle();
				var itemURL = "##" & page.getSlug();;
				var isFound = false;
				
				for ( var item in sMenuItems ) {
					if( item.getURL() ==  itemURL ){
						isFound = true;
					}
				}
				
				// if the menu item is not found
				if( !isFound ){
					
					// create the menu item
					var newMenuItem = EntityNew( 'cbURLMenuItem' );
					
					newMenuItem.setLabel( pageTitle );
					newMenuItem.setTarget( "_self" );
					newMenuItem.setURL( itemURL );
					
					oMenu.addMenuItem( newMenuItem );
				}
			}
			menuService.save( oMenu );			
		}
	}
	
	/**
	* Gets names of categories
	*/
	private string function entryCategories() {
		var categoryList = arraytoList( categoryService.getAllNames() );
		return categoryList;
	}
	
	/**
	* Gets all menu slugs
	*/
	private string function menus() { 
		var menuList = arraytoList( menuService.getAllSlugs() );
		return menuList;
	}
}
