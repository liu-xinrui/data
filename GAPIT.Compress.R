`GAPIT.Compress` <-
function(KI,kinship.cluster = "average",kinship.group = "Mean",GN=nrow(KI),Timmer,Memory){
#Object: To cluster individuals into groups based on kinship
#Output: GA, KG
#Authors: Alex Lipka and Zhiwu Zhang 
# Last update: April 14, 2011 
##############################################################################################
Timmer=GAPIT.Timmer(Timmer=Timmer,Infor="CP start") 
Memory=GAPIT.Memory(Memory=Memory,Infor="cp start")

# Extract the line names
line.names <- KI[,1]

Timmer=GAPIT.Timmer(Timmer=Timmer,Infor="Does this change memory0") 
Memory=GAPIT.Memory(Memory=Memory,Infor="Does this change memory0")

# Remove the first column of the kinship matrix, which is the line names
KI <- KI[ ,-1]

# Convert kinship to distance
#distance.matrix <- 2 - KI 


#distance.matrix.as.dist <- as.dist(distance.matrix)
#distance.matrix.as.dist <- as.dist(2 - KI)

Timmer=GAPIT.Timmer(Timmer=Timmer,Infor="CP distance") 
Memory=GAPIT.Memory(Memory=Memory,Infor="cp distance")

#print(paste("The value of kinship.cluster is ", kinship.cluster, sep = ""))



# hclust() will perform the hiearchical cluster analysis
#cluster.distance.matrix <- hclust(distance.matrix.as.dist, method = kinship.cluster)
#cluster.distance.matrix <- hclust(as.dist(2 - KI), method = kinship.cluster)
distance.matrix=dist(KI,upper=TRUE) #Jiabo Wang modified ,the dist is right function for cluster
cluster.distance.matrix=hclust(distance.matrix,method=kinship.cluster)
#cutree(out_hclust,k=3)

Timmer=GAPIT.Timmer(Timmer=Timmer,Infor="CP cluster") 
Memory=GAPIT.Memory(Memory=Memory,Infor="cp cluster")

# Cutree will assign lines into k clusters
#if(is.null(my.Group.custom)){
#    group.membership <- cutree(cluster.distance.matrix, k = GN)
#    }else{
#      group.membership <- my.Group.custom #coustom my group by input,by xinrui liu modifed  
#    }
#group.membership <- c(1,1,1,2,3,2,2,4,4,4,
#                        5,5,5,6,6,7,6,8,8,8,
#                        9,9,9,10,10,10,7,11,
#                        11,11,12,12,12,31,13,
#                        13,13,7,14,14,14,31,
#                        31,31,15,15,15,16,17,
#                        16,16,18,18,18,19,19,
#                        19,20,20,17,20,21,21,
#                        21,22,22,22,23,23,23,
#                        17,24,24,24,25,25,25,
#                        26,26,26,27,28,27,27,
#                        29,29,29,30,30,30,3,3,
#                        28,28)
group.membership <- c(4,4,4,1,1,1,1,5,5,5,6,6,6,
                      1,1,1,1,1,1,1,1,1,1,1,1,1,
                      1,1,1,1,1,1,1,7,1,1,1,1,1,
                      1,1,7,7,7,3,3,3,1,5,1,1,1,
                      1,1,1,1,1,1,1,5,1,3,3,3,1,
                      1,1,3,3,3,5,2,2,2,2,2,2,6,
                      6,6,1,1,1,1,2,2,2,1,1,1,1,
                      1,1,1)

compress_z=table(group.membership,paste(line.names))  #build compress z with group.membership

Timmer=GAPIT.Timmer(Timmer=Timmer,Infor="CP cutree") 
Memory=GAPIT.Memory(Memory=Memory,Infor="cp cutree")

#calculate group kinship
if(kinship.group == "Mean"){
#This matrix ooperation is much faster than tapply function for  "Mean"
x=as.factor(group.membership)
#b = model.matrix(~x-1) 
n=max(as.numeric(as.vector(x)))
b=diag(n)[x,]

KG=t(b)%*%as.matrix(KI)%*%b
CT=t(b)%*%(0*as.matrix(KI)+1)%*%b
KG=as.matrix(KG/CT)
rownames(KG)=c(1:nrow(KG))
colnames(KG)=c(1:ncol(KG))

Timmer=GAPIT.Timmer(Timmer=Timmer,Infor="CP calculation original")
Memory=GAPIT.Memory(Memory=Memory,Infor="cp calculation original")



}else{

gm=as.factor(group.membership)
kv=as.numeric(as.matrix(KI))
kvr=rep(gm,ncol(KI))
kvc=as.numeric(t(matrix(kvr,nrow(KI),ncol(KI))))

kInCol=t(rbind(kv,kvr,kvc))

rm(gm)
rm(kv)
rm(kvr)
rm(kvc)
rm(KI)
gc()



#This part does not work yet
#if(kinship.group == "Mean")
#    KG<- tapply(kInCol[,1], list(kInCol[,2], kInCol[,3]), mean)
if(kinship.group == "Max")    
    KG <- tapply(kInCol[,1], list(kInCol[,2], kInCol[,3]), max)
if(kinship.group == "Min")   
    KG <- tapply(kInCol[,1], list(kInCol[,2], kInCol[,3]), min)    
if(kinship.group == "Median")  
    KG <- tapply(kInCol[,1], list(kInCol[,2], kInCol[,3]), median)  
} #this is end of brancing "Mean" and the rest
    
Timmer=GAPIT.Timmer(Timmer=Timmer,Infor="CP calculation") 
Memory=GAPIT.Memory(Memory=Memory,Infor="cp calculation")

# add line names 
#GA <- data.frame(group.membership)
GA <- data.frame(cbind(as.character(line.names),as.numeric(group.membership) ))

#Timmer=GAPIT.Timmer(Timmer=Timmer,Infor="CP Final") 
#Memory=GAPIT.Memory(Memory=Memory,Infor="CP Final")

#write.table(KG, paste("KG_from_", kinship.group, "_Method.txt"), quote = FALSE, sep = "\t", row.names = FALSE,col.names = FALSE)

#print("GAPIT.Compress accomplished successfully!")
return(list(GA=GA, KG=KG,Timmer=Timmer,Memory=Memory))
}#The function GAPIT.Compress ends here
#=============================================================================================

