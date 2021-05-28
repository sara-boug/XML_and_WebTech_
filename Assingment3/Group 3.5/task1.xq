(:extracting the sample that is related to the current author :)
declare function local:sample($author, $dblp){ 
    for $author_ in $dblp//author where  $author_=$author
        return   $author_//parent::*
};

declare function local:extractAuthor($sample, $author) {
    for $authors in $sample
        for $author1 in  $authors//author where  $author1 != $author
         return $author1
};

declare function local:jointPub($samples , $author) {
        for $sample in $samples 
            for $author1 in $sample//author where $author1=$author
               
                return $author1/parent::*
};
let $dblp:=fn:doc("dblp-excerpt.xml")//dblp
return
<authors_coauthors>
return {
for $author in distinct-values( $dblp//author)
         let $sample := local:sample($author, $dblp)
         let $coauthors :=distinct-values(local:extractAuthor($sample, $author))
         let $c:= count($coauthors)
         return 
         <author>
         <name>{$author}</name>
         <coauthors number="{$c}">{
                   for $coauthor in $coauthors 
                       let $joinPubNumber :=count( local:jointPub($sample, $coauthor))
                       return <coauthor>
                             <name> {$coauthor}</name>
                             <nb_joint_pubs>{$joinPubNumber}</nb_joint_pubs>
                       </coauthor>
         }</coauthors>
       </author>
 }
</authors_coauthors>         
         
  
    
     