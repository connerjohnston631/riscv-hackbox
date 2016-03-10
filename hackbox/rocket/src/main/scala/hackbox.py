import sys

USAGE = '$python hackbox.py num_registers verilog_filename'
INSERT = '~$$THISISUNIQUE$$~'

def hackStringHelper(hackString, num_registers):
	result = ''
	for i in range(num_registers):
		result += '  ' + hackString.replace(INSTERT, str(i))
	return result

def main():	
	if len(sys.argv) != 2:
		print USAGE
		exit(0)
	(num_registers, verilog_file) = (int(sys.argv[1]), sys.argv[2])
	replacements = {'HACK_BOX_IO_INPUT_DECLARATIONS': hackStringHelper('val in_' + INSERT + ' = UInt(INPUT, width = 64)', num_registers),
 		'HACK_BOX_N': str(num_registers),
 		'HACK_BOX_ACCUMULATOR_VALUES': hackStringHelper('val accum_' + INSERT + '= regfile(' + INSERT + ')', num_registers),
 		'HACK_BOX_IO_INPUT_INTEGRATION': hackStringHelper('hackBox.io.in_' + INSERT + ' := accum_' + INSERT, num_registers)}
	full_file = open('../hackbox/rocc.hackbox', 'r').read()


if __name__ == "__main__":
	main()

