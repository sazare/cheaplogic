testall:
	@echo 
	@echo "TEST CHEAPLOGIC"
	julia test_cheaplogic.jl
	@echo 
	@echo "TEST KPLOGIC"
	julia test_kplogic.jl
	@echo 
	@echo "TEST LPS is not implemented"


lps:
	julia --load load_lps.jl spec/runspec.jl

clean:
	make -C spec clean
