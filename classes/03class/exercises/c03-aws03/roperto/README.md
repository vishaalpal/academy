# c03-aws03

## Command Execution Output
- Command used to create the Route53 zone:
```
I already have one managed by terraform
```

- Command used to add any new records to the zone 
```hcl-terraform
resource "aws_route53_record" "c03_aws03" {
  zone_id = aws_route53_zone.geral_net.id
  name    = "c03-aws03"
  type    = "CNAME"
  ttl     = 1000
  records = ["c03-aws02-293708117.ap-southeast-2.elb.amazonaws.com"]
}
```

- Post any findings, how option you decided to go with, records created, domain created, and anything else that you find interesting.
```
$ for _ in {1..10}; do curl -w "\n" c03-aws03.geral.net; done
ip-10-42-21-9.ap-southeast-2.compute.internal
ip-10-42-20-150.ap-southeast-2.compute.internal
ip-10-42-21-9.ap-southeast-2.compute.internal
ip-10-42-20-150.ap-southeast-2.compute.internal
ip-10-42-20-150.ap-southeast-2.compute.internal
ip-10-42-21-9.ap-southeast-2.compute.internal
ip-10-42-21-9.ap-southeast-2.compute.internal
ip-10-42-20-150.ap-southeast-2.compute.internal
ip-10-42-21-9.ap-southeast-2.compute.internal
ip-10-42-20-150.ap-southeast-2.compute.internal

$ nslookup c03-aws03.geral.net
Non-authoritative answer:
c03-aws03.geral.net	canonical name = c03-aws02-293708117.ap-southeast-2.elb.amazonaws.com.
Name:	c03-aws02-293708117.ap-southeast-2.elb.amazonaws.com
Address: 13.238.160.105
Name:	c03-aws02-293708117.ap-southeast-2.elb.amazonaws.com
Address: 13.236.35.58

Something interesting from the lookup is that the ALB also has its own redundancy
```

<!-- Don't change anything below this point-->
***
Answer for exercise [c03-aws03](https://github.com/devopsacademyau/academy/blob/aa1f1af00809616bdc1f8ba1d333b897c331d632/classes/03class/exercises/c03-aws03/README.md)
