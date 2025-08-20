# A heart for XML

I have always found the idea of XSLT very charming. Yes, JSON is more readable, smaller, and faster than XML; you can convert a JavaScript object into JSON with just one function call, and it is more forgiving. But I find XML cleaner, since validation can be handled declaratively via schemas, without writing extra code. On top of that, you get the highly sought-after clear separation between content and styling. And last but not least, pure HTML is still faster than HTML + JavaScript. So why not use XSLT in cases where no fancy JavaScript is needed — like landing pages?

Landing pages are static sites, right? How often do you actually change them? Maybe you update the content occasionally, but mostly they stay the same for a long time. That means they can be cached for extended periods, which in turn makes them very fast. And they need to stay that way. 

Recently, I decided to refresh my memories about XSLT and test the idea of a creation of a static site with it. I decided to use my CV for it. The whole process consists of two mandatory steps and one optional. The third step depends on how you decide to deploy the static site. 

## The content

First I wrote the content file. It goes like this:

```xml

<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="cv.xsl"?>
<cv>

    <styling>
        <text-color>#000000</text-color>
        <background-color>#188977</background-color>
        <job-details-text-color>#188977</job-details-text-color>
        <title-text-color>#000000</title-text-color>
        <name-text-color>#188977</name-text-color>
        <email-link-color>#188977</email-link-color>
        <line-color>#188977</line-color>
    </styling>
    
    <content>
        <title>
            Vesselin Beltchev - Independent Developer
        </title>
    <intro name="Vesselin Beltchev" title="Senior Java Developer">
        <paragraph>
            A developer who is comfortable with trying out stuff (old and new). 
        </paragraph>
    </intro>
    <contact phone="+1 234 567 88 99" email="@" mailto="vesselin.beltchev@bouncystream.tech" homepage-url="https://www.bouncystream.tech/en/" homepage-label="www">
    </contact>
    <photo src="nice-photo-of-me.jpeg">
    </photo>
    <jobs>
        <job atCompany="X" onPosition="Developer" from="08.2025" to="now">
            <tasks>
                <task>Trying out XSLT.</task>
            </tasks>
            <technologies>
                <technology type="DATA EXCHANGE FORMATS" version="1.0">XML</technology>
                <technology type="DATA EXCHANGE FORMATS">JSON</technology>
                <technology type="XML BASED LANGUAGES">XSLT</technology>
                <technology type="WEB SERVERS">nginx</technology>
                <technology type="VERSION CONTROL SYSTEMS">GIT</technology>
            </technologies>
        </job>
        
        <!-- ... -->
        

    </jobs>
    </content>
</cv>

```

In the styling section I've put some colour constants that I needed to be able to change fast. Of course they can be hard-coded in the stylesheet. The full XML includes a complete list of my jobs, with some highlights for each and every one. In the end there's also a simple education section for my educational background. I can imagine, that the amount of contents for a landing page would be even less. 

The line 

```xml

<?xml-stylesheet type="text/xsl" href="cv.xsl"?>

```

tells the XML processor which stylesheet to use for the transformation. The rest is your desired content structured as XML. What's a tag and what's an attribute is left up to you.

After finishing the content part, you save it in a file with extension *.xml*.

## The stylesheet

Next I came up with a XSL (eXtensible Stylesheet Language) file for positioning the contents and styling it. The file consists of a mixture of HTML and XSL instructions and functions. It looks something like this:

```xml

<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" indent="yes"/>

<xsl:template match="/">
<html>
  <head>
    <title>
      <xsl:value-of select="/cv/content/title"/>
    </title>
    
    <!-- -->
  </head>
  <body>
  ...
  </body>
<html>

</xsl:template>

```

In the first two lines we define the XML declaration and the type of the XML document - in this case *XSL* and the *XSL* namespace (Something JSON does not have and that makes XML extensible and modular. But that's another topic.). 

In the line:

```xml

<xsl:output method="html" indent="yes"/>

```

we define what the output of the transformation would look like. In my case that mattered, because I wanted to have `<meta>` tags in my final HTML, which are not well-formed - they don't have a closing tag. Since the the default output of a XSL transformation is XML, I got errors because of my `<meta>` tags. 

Now we come to the basic building block of an XSL transformation — the template. A template defines a set of instructions or markup that will be applied to matching XML nodes. This is a simplification, since a template can also include conditional logic, loops, and other processing, but the principle holds: it applies its contents to the nodes that match its pattern.
In the example above, the template matches the root node of my content file, transforms it into the specified HTML structure, and extracts the value of the `<title>` tag to insert into the HTML `<title>` element. The match attribute holds a XPath expression. A list of XPath functions can be found [here](https://developer.mozilla.org/en-US/docs/Web/XML/XPath/Reference/Functions).


This is probably the simplest form of a template can be. In a XSL file you can have multiple templates. Applying them works like this

```xml

<xsl:template name="renderTitle">
  <h2><xsl:value-of select="/cv/content/title"/></h2>
</xsl:template>

<xsl:template match="/">
  <xsl:call-template name="renderTitle"/>
</xsl:template>


```

Whether you use nested templates or not is a design decision. If you plan to apply a template multiple times on a tag that's named the same but is a child of a different tag, the concept may be useful. 

After I'm finished with the title I put the css styles in my html

```xml

  <style>
    body {
      background-color: <xsl:value-of select="cv/styling/background-color"/>;
      color: <xsl:value-of select="cv/styling/text-color"/>;
      overflow: hidden;
    }

    .container {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100svh;
        overflow: auto;
        box-sizing: border-box;
    }

    .box {
          display: flex;
          height: 90%;
          width: 800px;
          background: #FAFAFA;
          padding: 5px;
          border-radius: 5px;
          box-shadow: 0 6px 26px rgba(0, 0, 0, 0.5);

    }

    .left {
      text-align: center;
      margin-top: 2%;
      margin-bottom: 2%;
      height: 95%;
      border-right: dotted 2px <xsl:value-of select="cv/styling/line-color"/>;
      width: 25%;
    }

    .photo {
      width:85%;

    }

    ...

  </style>

```

This will be put after the `<head>` tag in my output html.

Next I put a contact section together with my photo on the left of the page.

```xml

  <body>
    <div class="container">
        <div class="box">

            <div class="left">
                <img class="photo" alt="Vesselin Beltchev">
                  <xsl:attribute name="src">
                    <xsl:value-of select="cv/content/photo/@src"/>
                  </xsl:attribute>
                </img>
                <div class="contact">
                  <p>
                    <a target="_blank">
                      <xsl:attribute name="href">
                        mailto:<xsl:value-of select="cv/content/contact/@mailto"/>
                      </xsl:attribute>
                      <xsl:value-of select="cv/content/contact/@email"/>
                    </a>
                  </p>
                  <p>
                    <a target="_blank">
                      <xsl:attribute name="href">
                        <xsl:value-of select="cv/content/contact/@homepage-url"/>
                      </xsl:attribute>
                      <xsl:value-of select="cv/content/contact/@homepage-label"/>
                    </a>
                  </p>
                </div>
            </div>
        
        ...
        
```

You can see some more extracting of values similar to the rendeing of the title. This case I use XPath to extract values from the attributes of the content tags.

On the right side of the page I put my professional experience and educational background.

Here

```xml

    <div class="right">
        <h1 class="name"><xsl:value-of select="cv/content/intro/@name"/></h1>
        <h2 class="title"><xsl:value-of select="cv/content/intro/@title"/></h2>
        <xsl:for-each select="cv/content/intro/paragraph">
        <p><xsl:value-of select="."/></p>
        </xsl:for-each>
    ...
              
```

I use a for loop to extract all the paragraphs from the intro tags.

Next I transform my jobs into neat paraphs.

```xml

    <div class="jobs">
    <h2 class="xperience">Professional Experience</h2>

    <xsl:for-each select="cv/content/jobs/job">

        <p class="jobDetails"><xsl:value-of select="./@from"/> - <xsl:value-of select="./@to"/>, <xsl:value-of select="./@onPosition"/>, <xsl:value-of select="./@atCompany"/></p>
        <xsl:for-each select="./tasks/task">
            <p><xsl:value-of select="."/></p>
        </xsl:for-each>

            <xsl:for-each select="technologies">

                <!-- handle technologies -->
                <p class="technologies">
                <xsl:for-each select="technology[generate-id() = generate-id(key('techByType', @type)[generate-id(ancestor::technologies[1]) = generate-id(current())][1])]">
                    <b><xsl:value-of select="@type"/></b>
                    ( <xsl:apply-templates select="key('techByType', @type)[generate-id(ancestor::technologies[1]) = generate-id(current()/ancestor::technologies[1])]"/> )
                </xsl:for-each>
                </p>

            </xsl:for-each>
        </xsl:for-each>
    </div>
    
    ...

```

The most complex transformation happens in the technologies section, wher I use aggregation to group the technologies into groups, depending on their type. For this I need to define a key by which to group. In this case this is the attribute type. It is defined like this:

```xml

<xsl:key name="techByType" match="technology" use="@type"/>


```

The definition of the key is placed outside any template. 

The outer loop goes through every `<technologies>` tag under a job and with the inner loop it gets each first `<technology>` tag of a type and extracts the value of the type to use as a group name. This is accomplised by using this rather complicated expression:

```xml

technology[generate-id() = generate-id(key('techByType', @type)[generate-id(ancestor::technologies[1]) = generate-id(current())][1])]

```

It translates into - give me the technology with the id that matches the first technology of the same type and same ancestor. Inside of the inner loop we apply a template that matches every `<technology>` tag of the same type and inside of the same `<technologies>` tag. The template looks like this:

```xml

<xsl:template match="technology">
    <xsl:value-of select="text()"/>
    <xsl:if test="position() != last()">
    ,
    </xsl:if>

</xsl:template>

```

It simply concatenates the names of the technologies and separates them with a comma. The *generate-id()* function is used to give unique ids to the nodes.

## Building and deploying

Building is as simple as calling

```

xsltproc cv.xml cv.xsl -o index.html

```

in any Linux console. 

The result is a single **index.html** file that can be be copied into the document root on your web server of choice. 

My static HTML CV can be found [here](https://cv.bouncystream.tech).
 
