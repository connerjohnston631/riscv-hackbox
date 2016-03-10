import sys

USAGE = '$python hackbox.py num_registers verilog_filename'
INSERT = '~$$THISISUNIQUE$$~'

def hackStringHelper(hackString, num_registers):
	result = ''
	for i in range(num_registers):
		result += '  ' + hackString.replace(INSERT, str(i)) + '\n'
	return result

def stringReplacementHelper(file_string, removal_string, insertion_string):
	return file_string.replace(removal_string, insertion_string)
	

def main():	
	if len(sys.argv) != 3:
		print USAGE
		exit(0)
	(num_registers, verilog_file) = (int(sys.argv[1]), sys.argv[2])
	replacements = {'HACK_BOX_IO_INPUT_DECLARATIONS': hackStringHelper('val in_' + INSERT + ' = UInt(INPUT, width = 64)', num_registers),
 		'HACK_BOX_N': str(num_registers),
 		'HACK_BOX_ACCUMULATOR_VALUES': hackStringHelper('val accum_' + INSERT + '= regfile(' + INSERT + ')', num_registers),
 		'HACK_BOX_IO_INPUT_INTEGRATION': hackStringHelper('hackBox.io.in_' + INSERT + ' := accum_' + INSERT, num_registers)}
	print str(replacements)
	full_file = open('../hackbox/rocc.hackbox', 'r').read()
	copy = full_file
	for key in replacements:
		copy = stringReplacementHelper(copy, key, replacements[key])

	for key in replacements:
		if key in copy:
			print 'THIS SHOULD NOT PRINT. THERE IS STILL REMOVABLE TEXT IN WRITING TEXT'
			print str(key)
			exit(0)
		if replacements[key] not in copy:
			print 'THIS SHOULD NOT PRINT. THERE IS EXPECTED TEXT MISSING FROM WRITING TEXT'
			exit(0)
	  

	raw_input('press enter to write to ../scala/rocc.scala')
	open('../scala/rocc.scala', 'w').write(copy)

	print 'converting the user-provided verilog into usable verilog (changing the module name)'
	verilog_module_name = verilog_file.split('.')[0]
	full_verilog = open('../verilog/' + verilog_file, 'r').read()
	print verilog_module_name
	print full_verilog
	print verilog_module_name in full_verilog
	copy_verilog = full_verilog.replace(verilog_module_name, 'HackBox')
	print verilog_module_name not in copy_verilog
	open('../verilog/verilogFromPython.v' , 'w').write(copy_verilog)
	print 'rocc.scala written. go to rocket-chip/fsim and run \'make verilog CONFIG=BlackBoxAccumulatorFPGAConfig\''
	print 'once that is done, go into the hackbox-script directory and execute the shell script to append the module'
	exit(0)
	

if __name__ == "__main__":
	main()
