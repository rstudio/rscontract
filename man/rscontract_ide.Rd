% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rscontract_ide.R
\name{rscontract_ide}
\alias{rscontract_ide}
\title{Mirrors the RStudio IDE connection contract arguments}
\usage{
rscontract_ide(
  connectionObject = NULL,
  type = "",
  host = "",
  icon = NULL,
  displayName = "",
  connectCode = "",
  disconnect = function() { },
  previewObject = function() { },
  listObjectTypes = default_types(),
  listObjects = function() { },
  listColumns = function() { },
  actions = NULL
)
}
\arguments{
\item{connectionObject}{The connection object. Default to NULL.}

\item{type}{Type of the connection.}

\item{host}{Name of the host}

\item{icon}{Path to the connection's icon. Defaults to NULL.}

\item{displayName}{The connection's name.}

\item{connectCode}{The text of the connection code.}

\item{disconnect}{Function to use to disconnect. Default to function(){}.}

\item{previewObject}{Function to run when the preview table icon is clicked on. Default to function(){}.}

\item{listObjectTypes}{Function that provides the structure of the connection.
The default function will work properly, it is going to be rare when it needs to be changed.}

\item{listObjects}{Function to run to get the catalogs, schema, tables or views based what has been
expanded on. Default to function(){}.}

\item{listColumns}{Function to run that pull the field information. Default to function(){}.}

\item{actions}{Additional buttons to add to the connection pane. Defaults to NULL.}
}
\value{
An `rs_contract_ide` class object
}
\description{
Creates an object that contains all of the necessary information to create a connection
contract. This function if meant as a lower level integration with the connections pane.
}
\examples{

str(rscontract_ide())

}
