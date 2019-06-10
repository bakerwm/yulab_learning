>Reference 

Van N E L, Pratt G A, Shishkin A A, et al. Robust transcriptome-wide discovery of RNA binding protein binding sites with enhanced CLIP (eCLIP):[J]. Nature Methods, 2016, 13(6):508.

>Note

#### 1. Improved RBP target identification with eCLIP
__Steps__:We observed that circular ligation like that used in iCLIP is often inefficient, and so we modified this step to add adapters in two separate steps: an indexed 3′ RNA adapter is ligated to the crosslinked RNA fragment while on the immunoprecipitation beads, and a 3′ single-stranded (ss) DNA adapter is ligated after reverse transcription (see Online Methods).
<br>
__Validation__:使用well-characterized RBP RBFOX2 来验证eCLIP的改善性。
>* 用eCT值（PCR cycle数目）评估indicating an ~1,000-fold increase in adapter-ligated preamplification products 
>* 通过map基因组所得到的的usable reads数目来比较iCLIP和eCLIP。 在IGF2BP1和IGF2BP2中也验证了。此步骤说明：enhanced adapter ligation efficiency significantly improves library
complexity for eCLIP experiments
>* Examination of individual binding sites revealed comparable read density between iCLIP and eCLIP for RBFOX2 binding sites。使用CLIPper的peak-calling对RBFOX2的motif分析
>* To validate that eCLIP identifies functional site，做了个实验。
>* 用RBFOX2和SLBP To interrogate the degree to which fragmentation affects eCLIP, we performed eCLIP with various RNase concentrations ranging from 0 U to 2,000 U
(per milliliter of lysate)这里好像又是在看enrichment。

#### 2. Input normalization improves CLIP signal-to-noise
__Object__： To directly assay the effect of SMInput normalization
>* we first profiled SLBP, as its exclusive binding to histone RNAs13 distinguishes true from false positive signals.
>* To quantify the effect of SMInput normalization at the peak level，用CLIPper软件中的peak calling算法和the numbers of reads overlapping each CLIPper-identified binding site in eCLIP and SMInput做分析。。。验证了the incorporation of SMInput normalization significantly improves signal-to-noise in identifying authentic binding sites.

#### 3. Reproducibility of eCLIP across replicate experiments
>* 前面的不太懂。。。什么P值的。。。？？？
>* IDR分析说明了eCLIP的 highly reproducible

#### 4. eCLIP enables large-scale in vivo RBP target profiling
>* 用eCT和fold值来。。。
>* 又用已报道的iCLIP数据和eCLIP数据对比，主要是对比usable reads，来说明eCLIP的高效性.

#### 5. CLIP experiments share common artifacts across RBPs
__Object__:  对cluster的一系列分析来验证一系列推论和结论
>* Our findings emphasize that CLIP analysis (particularly without proper input or other controls) that focuses on these classes of binding events should be carefully validated because of the high rate of false positives
>* 结论：SMInput normalization can identify true RNA binding events even at common false positive regions and can help characterize the wide array of RBPs known to directly regulate mitochondrial and small RNA processing and function