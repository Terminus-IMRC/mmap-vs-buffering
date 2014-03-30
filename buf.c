#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>

#include <sys/time.h>

void func(int8_t);

int main()
{
	int fd;
	long int i, j;
	int8_t *buf;
	struct timeval start, end;

	buf=(int8_t*)malloc(BUFFERSIZE*sizeof(int8_t));
	if(!buf){
		perror("malloc");
		exit(EXIT_FAILURE);
	}

	fd=open("db", O_RDWR, S_IRUSR | S_IWUSR);
	if(fd==-1){
		perror("open");
		exit(EXIT_FAILURE);
	}

	gettimeofday(&start, NULL);
	/* notice that floored */
	for(i=0; i<FILESIZE/BUFFERSIZE; i+=1){
		read(fd, buf, BUFFERSIZE);
		for(j=0; j<BUFFERSIZE; j++)
			func(buf[j]);
	}
	gettimeofday(&end, NULL);

	if(close(fd)==-1){
		perror("close");
		exit(EXIT_FAILURE);
	}

	free(buf);

	printf("start: %ld.%06ld\n", start.tv_sec, start.tv_usec);
	printf("end: %ld.%06ld\n", end.tv_sec, end.tv_usec);

	return 0;
}
