import Image from 'next/image';
import { MoreHorizontal } from 'lucide-react';

import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import {
  Pagination,
  PaginationContent,
  PaginationEllipsis,
  PaginationItem,
  PaginationLink,
  PaginationNext,
  PaginationPrevious,
} from '@/components/ui/pagination';
import { useEffect, useState } from 'react';
import axios from 'axios';
import { Gender, Review } from '@/lib/models';
import useToken from '@/lib/useToken';
import { date } from '@/lib/utils';
import Link from 'next/link';
import { toast } from '@/components/ui/use-toast';

interface TableData {
  data: Review[];
  page: number;
  pageSize: number;
  totalCount: number;
}

export default function ReviewsTable() {
  const SERVER_URL = process.env.NEXT_PUBLIC_SERVER_ROOT_URL;
  const reviewEndpoint = `${SERVER_URL}/api/admin/review`;
  const [tableData, setTableData] = useState<TableData>({
    page: 1,
    data: [],
    pageSize: 0,
    totalCount: 0,
  });
  const { getToken } = useToken();
  const [error, setError] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);

  const refreshData = () => {
    useEffect(() => {
      const token = getToken();
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      const query = `${reviewEndpoint}?page=${tableData.page}`;

      axios.get(query, config).then(
        (result) => {
          setIsLoaded(true);
          setTableData(result.data as TableData);
        },
        (error) => {
          setIsLoaded(true);
          setError(error);
        },
      );
    }, [tableData.page]);
  };

  refreshData();

  function previousPage() {
    if (tableData.page > 1) {
      setTableData({ ...tableData, page: tableData.page - 1 });
    }
  }

  function isLastPage() {
    return tableData.page * tableData.pageSize >= tableData.totalCount;
  }

  function nextPage() {
    if (!isLastPage()) {
      setTableData({ ...tableData, page: tableData.page + 1 });
    }
  }

  function deleteReview(id: number) {
    const token = getToken();
    const config = {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    };

    return () => {
      axios.delete(`${reviewEndpoint}/${id}`, config).then(
        (result) => {
          setTableData({
            ...tableData,
            data: tableData.data.filter((item) => item.id !== id),
          });
          const item = tableData.data.find((item) => item.id === id)!;
          toast({
            title: 'Review deleted.',
            description: `Review for ${item.name} by ${item.author} has been deleted successfully.`,
          });
        },
        (error) => {
          console.error(error);
        },
      );
    };
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>Reviews</CardTitle>
        <CardDescription>Manage reviews here.</CardDescription>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead className="hidden w-[100px] sm:table-cell">
                <span className="sr-only">Image</span>
              </TableHead>
              <TableHead>Author</TableHead>
              <TableHead>Name</TableHead>
              <TableHead>Gender</TableHead>
              <TableHead>Rating</TableHead>
              <TableHead className="hidden md:table-cell">Created at</TableHead>
              <TableHead>
                <span className="sr-only">Actions</span>
              </TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {tableData.data.map((item, index) => (
              <TableRow key={index}>
                <TableCell className="hidden sm:table-cell">
                  {item.imageUrls.length === 0 ? (
                    <div className="aspect-square h-16 w-16 rounded-md bg-gray-100"></div>
                  ) : (
                    <Image
                      alt="Product image"
                      className="aspect-square rounded-md object-cover"
                      height="64"
                      src={item.imageUrls[0]}
                      width="64"
                    />
                  )}
                </TableCell>
                <TableCell className="font-medium">{item.author}</TableCell>
                <TableCell>{item.name}</TableCell>
                <TableCell>
                  <Badge variant="outline">{Gender[item.gender]}</Badge>
                </TableCell>
                <TableCell className="hidden md:table-cell">
                  {item.rating}
                </TableCell>
                <TableCell className="hidden md:table-cell">
                  {date(item.dateCreated)}
                </TableCell>
                <TableCell>
                  <DropdownMenu>
                    <DropdownMenuTrigger asChild>
                      <Button aria-haspopup="true" size="icon" variant="ghost">
                        <MoreHorizontal className="h-4 w-4" />
                        <span className="sr-only">Toggle menu</span>
                      </Button>
                    </DropdownMenuTrigger>
                    <DropdownMenuContent align="end">
                      <DropdownMenuLabel>Actions</DropdownMenuLabel>
                      <DropdownMenuItem>
                        <Button
                          variant="destructive"
                          onClick={deleteReview(item.id)}
                        >
                          Delete
                        </Button>
                      </DropdownMenuItem>
                    </DropdownMenuContent>
                  </DropdownMenu>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </CardContent>
      <CardFooter>
        <div className="w-auto text-xs text-muted-foreground">
          Showing{' '}
          <strong>
            {tableData.page * tableData.pageSize - tableData.pageSize + 1}-
            {tableData.page * tableData.pageSize}
          </strong>{' '}
          of <strong>{tableData.totalCount}</strong> reviews
        </div>
        <Pagination>
          <PaginationContent>
            {tableData.page > 1 && (
              <PaginationItem>
                <PaginationPrevious href="#" onClick={previousPage} />
              </PaginationItem>
            )}
            <PaginationItem>
              <PaginationLink>{tableData.page}</PaginationLink>
            </PaginationItem>
            {!isLastPage() && (
              <PaginationItem>
                <PaginationNext href="#" onClick={nextPage} />
              </PaginationItem>
            )}
          </PaginationContent>
        </Pagination>
      </CardFooter>
    </Card>
  );
}
