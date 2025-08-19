<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" indent="yes"/>

<xsl:key name="techByType" match="technology" use="@type"/>

<xsl:template match="/">
  <html>
  <head>
    <title>
      <xsl:value-of select="/cv/content/title"/>
    </title>

  <meta name="author" content="Vesselin Beltchev" />
  <meta name="description" content="Static HTML Version of my CV generated with XSLT." />

  <meta property="og:title" content="Vesselin Beltchev | Independent Software Engineer and Senior Java Developer" />
  <meta property="og:description" content="Static HTML Version of my CV generated with XSLT." />
  <meta property="og:image" content="https://www.bouncystream.tech/en/vesselin-beltchev.jpeg" />
  <meta property="og:url" content="https://cv.bouncystream.tech/" />
  <meta property="og:type" content="website" />
  <!-- Optional: For better social media sharing -->
  <meta property="og:site_name" content="cv.bouncystream.tech" />
  <meta property="og:locale" content="en_US" />

  <link rel="canonical" href="https://cv.bouncystream.tech/" />

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "Person",
    "name": "Vesselin Beltchev",
    "jobTitle": "Independent Software Engineer and Senior Java Developer",
    "url": "https://www.bouncystream.tech/en/",
    "image": "https://www.bouncystream.tech/en/vesselin-beltchev.jpeg",
    "sameAs": [
      "https://www.linkedin.com/in/bouncystream/"
    ],
    "description": "Static HTML Version of my CV generated with XSLT."
  }
  </script>

  </head>
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

    .right {
      width: 75%;
      margin: 15px;
      overflow: auto;
      padding-right: 20px;
    }

    .contact {
      margin: 1em;
      display: flex;
      flex-direction: column;
      align-items: flex-end;
    }

    .contact p{
      hyphen: auth;
      word-wrap: break-word;
      margin-top: 0.1em;
      line-height: 1.1em;
      text-align: right;
    }

    .contact a {
      color: <xsl:value-of select="cv/styling/email-link-color"/>;
      text-decoration: none;
    }

    .contact a:hover {
      color: <xsl:value-of select="cv/styling/email-link-color"/>;
      text-decoration:underline;
    }

    .jobs, .edu {
      width: 100%;
    }

    .jobDetails, .school {
      font-style: italic;
      font-weight: 600;
      color: <xsl:value-of select="cv/styling/job-details-text-color"/>;
    }

    .title {
      font-style: italic;
      font-weight: 600;
      color: <xsl:value-of select="cv/styling/title-text-color"/>;
    }

    .name {
      font-style: italic;
      font-weight: 800;
      color: <xsl:value-of select="cv/styling/name-text-color"/>;
    }

    .xperience, .education {
      font-style: italic;
      font-weight: 600;
    }

    .technologies {
      hyphens: auto;
      word-break: break-word;
    }

  </style>

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
                  <p> <xsl:value-of select="cv/content/contact/@phone"/> </p>
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

            <div class="right">
              <h1 class="name"><xsl:value-of select="cv/content/intro/@name"/></h1>
              <h2 class="title"><xsl:value-of select="cv/content/intro/@title"/></h2>
              <xsl:for-each select="cv/content/intro/paragraph">
                <p><xsl:value-of select="."/></p>
              </xsl:for-each>


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

            <div class="edu">
            <h2 class="education">Education</h2>

            <xsl:for-each select="cv/content/education/school">

                <p class="school"><xsl:value-of select="./@from"/> - <xsl:value-of select="./@to"/>, <xsl:value-of select="."/></p>
                <p><xsl:value-of select="./@degree"/>, <xsl:value-of select="./@fieldOfStudy"/></p>

              </xsl:for-each>
            </div>
          </div>
        </div>
    </div>
  </body>
  </html>
</xsl:template>

<xsl:template match="technology">
    <xsl:value-of select="text()"/>
    <xsl:if test="position() != last()">
    ,
    </xsl:if>

</xsl:template>

</xsl:stylesheet>
