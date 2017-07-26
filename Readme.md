# lavaan.graph

This takes a model statement of a lavaan model in R and renders it in dot code (part of graphviz), uses dot to compile it to a jpg and used the jpeg package to display it on the active R display device. It also leave a copy in the working directory.

### Prerequisites

This function requires that graphviz (http://www.graphviz.org) is installed on your machine and has been added to the PATH

### Description

creates and displays a directed graph from fitted lavaan object. Significant paths are show with bolded edges. Non-significant edges shown as dashed edges. 

### Usage

lavaan.graph(fit.sem,outfile="outfile",coeff=FALSE,stand=FALSE,show.corr=TRUE,sig.fig=2,out.format=NULL,dpi=300,dot.code=NULL,categorical=NULL)

fit.sem	   	a lavaan fit object

outfile    	a string of the name for the output (the .dot file, the .jpg and other optional formats)

coeff		an option to include parameter estimates on edges. Default is coeff=FALSE

stand		an option to indicate if parameter estimates should be shown as standardized

show.corr	an option to indicate if double-headed arrows should be shown. Default is show.corr=TRUE

sig.fig         an integer to indicate the number of places after decimal to round estimates

out.format 	a string indicating optional addition format to have graph rendered. options 		
	   	include('pdf','png','tiff'...see http://www.graphviz.org/doc/info/output.html for full list.

dpi	   	dpi of the jpg output

dot.code   	optional lines of dot code to be added to top of output dot file

categorical 	optional list of categorical variables and their levels in form 	
		list(c1=c('l1','l2',...),c2=c('l3','l4'))

### Value

a .dot file containing the description of the lavaan model in the dot language and a rendered jpg of the model

#### Examples

#simulate data
x<-rnorm(500,0,3)
w<-2*x + rnorm(500,0,2)
z<-1*w + rnorm(500,0,3)
y<-2*z + 4*w + rnorm(500,0,2)

#write lavaan model
mod1<-'w\~x  
       z\~w  
       y~z+w'

#fit model

fit.mod1<-sem(mod1,data=data.frame(x,w,z,y))

#show graph
lavaan.graph(fit.mod1)


## Authors

* **Donald R. Schoolmaster Jr** - *Initial work* 

