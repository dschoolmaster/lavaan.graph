#05/25/2014 11.25pm
#07/21/2017 12:44am Updated to work with categorial variables and latent variables

lavaan.graph<-function(fit.sem,outfile="outfile",coeff=FALSE,stand=FALSE,show.corr=TRUE,sig.fig=2,out.format=NULL,dpi=100,dot.code=NULL,categorical=NULL){
  plot_jpeg = function(path, add=FALSE)
  {
    require('jpeg')
    jpg = readJPEG(path, native=T) # read the file
    res = dim(jpg)[1:2] # get the resolution
    if (!add) # initialize an empty plot area if add==FALSE
      plot(1,1,xlim=c(1,res[1]),ylim=c(1,res[2]),asp=res[1]/res[2],type='n',xaxs='i',yaxs='i',xaxt='n',yaxt='n',xlab='',ylab='',bty='n')
    rasterImage(jpg,1,1,res[1],res[2])
  }

if(!stand&&sig.fig==2)sig.fig=3
ests<-parameterEstimates(fit.sem,standardized=stand)

if(!is.null(categorical))for(i in 1:length(categorical)){
  who<-which(ests$op!="~~"&ests$rhs%in%categorical[[i]])
  rp<-ests[who[1],]
  rp[,'rhs']<-names(categorical)[i]
  rp[,c("est","se","z","pvalue","ci.lower","ci.upper")]<-NA
  ests<-ests[-who,]  
  ests<-rbind(ests,rp)}

ests1<-ests[which(ests$op=="~"),1:3]
exo<-ests1[!ests1[,"rhs"]%in%ests1[,"lhs"],"rhs"]
exo<-exo[!duplicated(exo)]
if(stand)est.type="std.all" else est.type="est"
node.names=c(fit.sem@"Model"@"dimNames"[[1]][[1]],fit.sem@"Model"@"dimNames"[[1]][[2]])
if(!is.null(categorical)){
  for(i in 1:length(categorical)){
    node.names[node.names%in%categorical[[i]]]<-names(categorical[i])
    node.names<-unique(node.names)
  }
}
if(coeff)r2=inspect(fit.sem,"rsquare")
pvals<-ifelse(ests[,7]<0.05,"bold","dashed")

sink(paste(outfile,".dot",sep=""))
cat("digraph LavaanSEM{",sep="\n")
cat(paste("graph [ dpi = ",dpi,"]",sep=""),sep="\n")
cat(paste("{rank=min;","\"",exo,"\"","}",sep=""),sep="\n")
if(!is.null(dot.code))cat(dot.code,sep="\n")
if(!coeff)
  for(i in 1:length(node.names)){
    if(node.names[i]%in%unique(ests[ests$op=="=~",1]))
    cat(paste("\"",node.names[i],"\"","[shape=oval]",sep=""),sep="\n" ) else
    cat(paste("\"",node.names[i],"\"","[shape=box]",sep=""),sep="\n" )}  else

  for(i in 1:length(node.names)){
  if(node.names[i]%in%unique(ests[ests$op=="=~",1]))
    cat(paste("\"",node.names[i],"\"","[shape=oval,label=\"",node.names[i],"\\n",ifelse(!is.na(r2[node.names[i]]),round(r2[node.names[i]],2),""),"\"]",sep=""),sep="\n") else
    cat(paste("\"",node.names[i],"\"","[shape=box, label=\"",node.names[i],"\\n",ifelse(!is.na(r2[node.names[i]]),round(r2[node.names[i]],2),""),"\"]",sep=""),sep="\n")
  }

for(i in 1:length(ests[,est.type])){
     if(ests[,"op"][i]=="~"){cat(paste("\"",ests[,"rhs"][i],"\"","->","\"",ests[,"lhs"][i],"\"",sep=""))
     if(!coeff)cat("\n") else cat(paste("[label=",round(ests[,est.type][i],sig.fig),",style=",pvals[i],"]",sep=""),sep="\n")}

    if(ests[,"op"][i]=="=~"){cat(paste("\"",ests[,"rhs"][i],"\"","->","\"",ests[,"lhs"][i],"\"",sep=""))
    if(!coeff)cat("[dir=back]\n") else cat(paste("[label=",round(ests[,est.type][i],sig.fig),",dir=back",",style=",pvals[i],"]",sep=""),sep="\n")}
  
     if(show.corr&&ests[,"op"][i]=="~~"&&ests[,"rhs"][i]!=ests[,"lhs"][i])
     cat(paste("\"",ests[,"rhs"][i],"\"","->","\"",ests[,"lhs"][i],"\"","[label=",round(ests[,est.type][i],sig.fig),",dir=both",",style=",pvals[i],"]",sep=""),sep="\n")
  }
cat("}")
sink()
out<-paste("dot -Tjpg ",outfile,".dot ", "-o ",outfile,".jpg",sep="")
system(out)
if(!is.null(out.format))system(paste("dot -T",out.format," ",outfile,".dot -o ",outfile,".",out.format,sep=""))
plot_jpeg(paste(outfile,".jpg",sep=""))
}
